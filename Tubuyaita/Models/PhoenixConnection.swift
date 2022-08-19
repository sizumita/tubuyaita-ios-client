//
//  PhoenixConnection.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/19.
//

import Foundation
import Combine
import SwiftPhoenixClient
import Sodium
import Clibsodium
import CryptoKit


struct Retweet : Codable {
    var host: String
    var port: String
    var id: String
}

struct Content : Codable {
    var body: Optional<String>
    var retweet: Optional<Retweet>
}

struct EncryptedContent : Codable {
    // 文字列になってるContent
    var content: String
    var receiverPublicKey: String
    var nonce: String
}

struct MessageContent : Codable {
    // if encrypted contents
    var contents: Optional<[EncryptedContent]>
    // if content
    var body: Optional<String>
    var retweet: Optional<Retweet>
    var timestamp: UInt64
}



class PhoenixConnection {
    private let socket: Socket
    private var messageChannel: Channel?
    private let sodium = Sodium()
    private var url: String
    
    let subject = PassthroughSubject<Message, Never>()
    
    init(url: String) {
        self.url = url
        self.socket = Socket(url)
    }
    
    func connect() {
        socket.delegateOnOpen(to: self) { (self) in
            print("Connected")
        }
        
        socket.delegateOnClose(to: self) { (self) in
            print("Disconnected")
        }
        
        socket.delegateOnMessage(to: self) { (self, msg) in
            self.recieveMessage(msg: msg)
        }
        
        socket.delegateOnError(to: self) { (self, err) in
            print(err)
        }

        let channel = socket.channel("message")
        self.messageChannel = channel
        self.messageChannel?.join()
        self.socket.connect()
    }
    
    func disconnect() {
        self.socket.disconnect()
    }
    
    private func recieveMessage(msg: SwiftPhoenixClient.Message) {
        if msg.event == "create_message" {
            let expectedHash = SHA512.hash(data: ((msg.payload["contents"] as? String)?.data(using: .utf8))!)
            if !verifyContent(publicKey: msg.payload["publicKey"] as? String ?? "", sign: msg.payload["sign"] as? String ?? "", message: Data(Array(expectedHash))) {
                print("Verify failed")
                return
            }
            
            let decoder = JSONDecoder()
            guard let content: MessageContent = try? decoder.decode(MessageContent.self, from: (msg.payload["contents"] as? String ?? "").data(using: .utf8)!) else {
                print("json is invalid!")
                return
            }
            // if encrypted content
            if content.contents != nil {
                
            } else {
                let message = Message(id: sodium.utils.bin2hex(Array(expectedHash))!, content: content.body!, publicKey: msg.payload["publicKey"]! as! String, sign: msg.payload["sign"]! as! String)
                subject.send(message)
            }
        }
    }
    
    func verifyContent(publicKey: String, sign: String, message: Data) -> Bool {
        let publicKey = sodium.utils.hex2bin(publicKey)
        let sign = sodium.utils.hex2bin(sign)
        if publicKey == nil || sign == nil {
            return false
        }

        guard message.withUnsafeBytes({ p in
            crypto_sign_verify_detached(sign!, p, UInt64(message.count), publicKey!)
        }) == 0 else {
            return false
        }
        return true
    }
    
}
