//
//  TimeLineModel.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/19.
//

import Foundation
import SwiftUI
import Combine
import Sodium
import CryptoKit
import CoreData

struct Cursor : Codable {
    var t: Int64
    var v: Int
    var h: String
}

struct ReceivedMessage : Codable {
    var contents_hash: String
    var created_at: Int64
    var public_key: String
    var raw_message: String
    var sign: String
}

class TimeLineModel : ObservableObject {
    var server: Server
    private var sodium = Sodium()
    private var context = PersistenceController.shared.container.viewContext
    @Published var searchText = ""

    init(server: Server) {
        self.server = server
    }
    
    func getAccount(publicKey: String) -> Account? {
        let predicate = NSPredicate(format: "publicKey == %@ && server == %@", publicKey, server)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        request.predicate = predicate
        
        do {
            let accounts = try context.fetch(request) as! [Account]
            return accounts.first
        } catch {
            return nil
        }
    }
    
    func loadMessages(history: FetchHistory, isFirst: Bool, previousHistory: FetchHistory?) {
        let cursor = Cursor(t: history.lastMessageTimestamp!.toUnixTimeMilliseconds(), v: 1, h: history.lastMessageHash!.hexa)
        let encoder = JSONEncoder()
        guard let jsonContent = try? encoder.encode(cursor) else {
           return
        }
        let base64Cursor = jsonContent.base64EncodedString()
        
        // MARK: send request
        let url = URL(string: String(format: "http://%@:%d/api/v1/messages?cursor=%@", server.address!, server.port, base64Cursor))!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            var isEnd = false
            var addedPublicKey: [String] = []
            
            guard let data = data else { return }
            let decoder = JSONDecoder()
            
            guard let _msgs: [ReceivedMessage] = try? decoder.decode([ReceivedMessage].self, from: data) else {
                return
            }
            let msgs = _msgs.sorted { msg1, msg2 in
                msg1.created_at > msg2.created_at
            }
            for message in msgs {
                if previousHistory != nil {
                    if previousHistory!.latestMessageHash == self.sodium.utils.hex2bin(message.contents_hash)!.data
                        && previousHistory!.latestMessageTimestamp == Date(milliseconds: message.created_at) {
                        isEnd = true
                        break
                    }
                }
                guard let content: MessageContent = try? decoder.decode(MessageContent.self, from: message.raw_message.data(using: .utf8)!) else {
                    print("fail content")
                    return
                }
                let sign = Data(self.sodium.utils.hex2bin(message.sign)!)
                let contentHash = Data(Array(SHA512.hash(data: (message.contents_hash.data(using: .utf8))!)))
                // TODO: validate
                let _ = Message(context: self.context, server: self.server, contentHash: contentHash, content: content, sign: sign, publicKey: message.public_key)
                
                // MARK: Add account
                if !addedPublicKey.contains(message.public_key) {
                    let acc = self.getAccount(publicKey: message.public_key)
                    if acc == nil {
                        let account = Account(context: self.context)
                        account.server = self.server
                        account.publicKey = message.public_key
                        
                        addedPublicKey.append(message.public_key)
                    } else {
                        addedPublicKey.append(acc!.publicKey!)
                    }
                }
            }
            print(isEnd)
            print(msgs.count)
            if isEnd {
                previousHistory!.latestMessageHash = history.latestMessageHash
                previousHistory!.latestMessageTimestamp = history.latestMessageTimestamp
                try? self.context.save()
                self.context.delete(history)
            } else {
                if msgs.isEmpty {
                    history.fetched = true
                } else {
                    history.lastMessageTimestamp = Date(milliseconds: Int64(msgs.last!.created_at))
                    history.lastMessageHash = Data(Array(SHA512.hash(data: (msgs.last!.contents_hash.data(using: .utf8))!)))
                }
            }

            try? self.context.save()
        }

        task.resume()
    }
}
