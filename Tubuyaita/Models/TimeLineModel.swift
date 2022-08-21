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

    init(server: Server) {
        self.server = server
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
            var lastMessage: ReceivedMessage?
            
            guard let data = data else { return }
            let decoder = JSONDecoder()
            
            guard let msgs: [ReceivedMessage] = try? decoder.decode([ReceivedMessage].self, from: data) else {
                return
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
                let publicKey = Data(self.sodium.utils.hex2bin(message.public_key)!)
                let contentHash = Data(Array(SHA512.hash(data: (message.contents_hash.data(using: .utf8))!)))
                // TODO: validate
                let _ = Message(context: self.context, server: self.server, contentHash: contentHash, content: content, sign: sign, publicKey: publicKey)
                if lastMessage != nil {
                    if lastMessage!.created_at < message.created_at {
                        lastMessage = message
                    }
                } else {
                    lastMessage = message
                }
            }
            if isEnd {
                previousHistory!.latestMessageHash = history.latestMessageHash
                previousHistory!.latestMessageTimestamp = history.latestMessageTimestamp
                self.context.delete(history)
            } else {
                if msgs.isEmpty {
                    history.fetched = true
                } else {
                    history.lastMessageTimestamp = Date(milliseconds: Int64(lastMessage!.created_at))
                    history.lastMessageHash = Data(Array(SHA512.hash(data: (lastMessage!.contents_hash.data(using: .utf8))!)))
                }
            }

            try? self.context.save()
        }

        task.resume()
    }
}
