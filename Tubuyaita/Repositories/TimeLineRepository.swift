//
// Created by Sumito Izumita on 2022/08/24.
//

import Foundation
import Combine
import SwiftPhoenixClient
import Sodium
import Clibsodium
import CryptoKit
import CoreData
import SwiftUI

enum SocketStatus {
    case connect
    case disconnect
    case error(Error)
}

enum FetchErrorStatus : Error {
    case httpRequestFailed
    case jsonParseFailed
    case invalidHexString
    case verifyFailed
}

struct Cursor : Codable {
    /// Timestamp
    var t: Int
    /// Version
    var v: Int
    /// Hash
    var h: String

    func json() -> Data {
        let encoder = JSONEncoder()
        return try! encoder.encode(self)
    }
}

class TimeLineRepository : ObservableObject {
    private var socket: Socket?
    private let sodium = Sodium()
    private var messageChannel: Channel?
    private let context = PersistenceController.shared.container.viewContext
    var messageSubject = PassthroughSubject<TubuyaitaMessage, Never>()
    private var socketSubject = PassthroughSubject<SocketStatus, Never>()

    init() {}

    /// MARK: Websocket

    ///
    /// Connect Websocket
    func connect(server: Server) {
        socket = Socket("ws://\(server.address!):\(server.port)/sockets")

        socket!.delegateOnOpen(to: self) { (self) in
            self.socketSubject.send(.connect)
        }
        socket!.delegateOnClose(to: self) { (self) in
            self.socketSubject.send(.disconnect)
        }
        socket!.delegateOnError(to: self) { (self, err) in
            self.socketSubject.send(.error(err))
        }
        socket!.delegateOnMessage(to: self) { (self, message) in
            if message.event == "create_message" {
                self.produceMessage(msg: message, server: server)
            }
        }

        let channel = socket!.channel("message")
        messageChannel = channel
        messageChannel!.join()
        socket!.connect()
    }

    func disconnect() {
        messageChannel?.leave()
        socket?.disconnect()
    }

    func messagePublisher() -> AnyPublisher<TubuyaitaMessage, Never> {
        messageSubject.eraseToAnyPublisher()
    }

    func socketPublisher() -> AnyPublisher<SocketStatus, Never> {
        socketSubject.eraseToAnyPublisher()
    }

    private func produceMessage(msg: SwiftPhoenixClient.Message, server: Server) {
        guard let publicKey = msg.payload["publicKey"] as? String else {
            return
        }
        guard let sign = msg.payload["sign"] as? String else {
            return
        }
        guard let contents = msg.payload["contents"] as? String else {
            return
        }
        let expectedHash = Data(Array(SHA512.hash(data: contents.data(using: .utf8)!)))
        guard let rawPublicKey = sodium.utils.hex2bin(publicKey) else {
            return
        }
        guard let rawSign = sodium.utils.hex2bin(sign) else {
            return
        }
        // Check sign
        if !sodium.signVerifyDetached(publicKey: rawPublicKey, sign: rawSign, message: expectedHash) {
            return
        }

        guard let phoenixMessageContents = PhoenixMessageContents(json: contents.data(using: .utf8)!) else {
            return
        }

        messageSubject.send(processMessage(server: server, contents: phoenixMessageContents, publicKey: publicKey, id: expectedHash.hexa))
    }

    private func getIsMentioned(body: String) -> Bool {
        // TODO: Improve
        false
    }

    private func getAccount(publicKey: String, server: Server) -> Account? {
        let predicate = NSPredicate(format: "publicKey == %@ && server == %@", publicKey, server)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        request.predicate = predicate

        return (try? context.fetch(request) as? [Account])?.first
    }


    /// MARK: HTTP

    ///
    /// HTTP Way getting messages
    /// - Parameters:
    ///   - server: Server
    ///   - cursor: Cursor
    func fetchMessages(server: Server, cursor: Cursor?) async -> Result<[TubuyaitaMessage], FetchErrorStatus> {
        var url: URL!
        if cursor != nil {
            let base64Cursor = cursor!.json().base64EncodedString()

            url = URL(string: String(format: "http://%@:%d/api/v1/messages?cursor=%@", server.address!, server.port, base64Cursor))!
        } else {
            url = URL(string: String(format: "http://%@:%d/api/v1/messages", server.address!, server.port))!
        }
        guard let (data, response) = try? await URLSession.shared.data(from: url) else {
            return .failure(.httpRequestFailed)
        }
        let decoder = JSONDecoder()
        guard var messages: [ReceivedMessage] = try? decoder.decode([ReceivedMessage].self, from: data) else {
            return .failure(.jsonParseFailed)
        }
        messages.sort { (v, v2) in
            v.created_at > v2.created_at
        }

        var parsedMessages: [TubuyaitaMessage] = []

        for message in messages {
            let expectedHash = Data(Array(SHA512.hash(data: message.raw_message.data(using: .utf8)!)))
            // MARK: verify
            guard let rawPublicKey = sodium.utils.hex2bin(message.public_key) else {
                return .failure(.invalidHexString)
            }
            guard let rawSign = sodium.utils.hex2bin(message.sign) else {
                return .failure(.invalidHexString)
            }
            if !sodium.signVerifyDetached(publicKey: rawPublicKey, sign: rawSign, message: expectedHash) {
                return .failure(.verifyFailed)
            }
            guard let phoenixMessageContents = PhoenixMessageContents(json: message.raw_message.data(using: .utf8)!) else {
                return .failure(.jsonParseFailed)
            }
            parsedMessages.append(processMessage(server: server, contents: phoenixMessageContents, publicKey: message.public_key, id: expectedHash.hexa))
        }
        return .success(parsedMessages)
    }

    /// Shared

    private func processMessage(server: Server, contents: PhoenixMessageContents, publicKey: String, id: String) -> TubuyaitaMessage {
        let timestamp = Date(milliseconds: Int64(contents.timestamp))
        if contents.body == nil {
            // is encrypted
            // TODO Improve
            let message = TubuyaitaMessage(
                    id: id,
                    isContentEncrypted: false,
                    isMentioned: getIsMentioned(body: ""),
                    parsedContent: "Encrypted",
                    publicKey: publicKey,
                    timestamp: timestamp,
                    account: getAccount(publicKey: publicKey, server: server)
            )
            return message
        } else {
            // is normal
            let message = TubuyaitaMessage(
                    id: id,
                    isContentEncrypted: false,
                    isMentioned: getIsMentioned(body: contents.body!),
                    parsedContent: contents.body!,
                    publicKey: publicKey,
                    timestamp: timestamp,
                    account: getAccount(publicKey: publicKey, server: server)
            )
            return message
        }
    }
}
