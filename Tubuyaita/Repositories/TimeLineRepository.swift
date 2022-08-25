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
            print(err)
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
        socket!.disconnect()
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

        let timestamp = Date(milliseconds: Int64(phoenixMessageContents.timestamp))
        if phoenixMessageContents.body == nil {
            // is encrypted
            // TODO Improve
        } else {
            // is normal
            let message = TubuyaitaMessage(
                    id: expectedHash.hexa,
                    isContentEncrypted: false,
                    isMentioned: getIsMentioned(body: phoenixMessageContents.body!),
                    parsedContent: phoenixMessageContents.body!,
                    publicKey: publicKey,
                    timestamp: timestamp,
                    account: getAccount(publicKey: publicKey, server: server)
            )
            messageSubject.send(message)
        }
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
    func fetchMessages(server: Server, cursor: Cursor) {

    }
}
