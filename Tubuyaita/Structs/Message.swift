//
//  Message.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/19.
//

import Foundation


struct TubuyaitaMessage : Identifiable {
    var id: String
    var isContentEncrypted: Bool
    var isMentioned: Bool
    var parsedContent: String
    var publicKey: String
    var timestamp: Date

    var account: Account?
}

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

struct PhoenixMessageContents : Codable {
    // if encrypted contents
    var contents: Optional<[EncryptedContent]>
    // if content
    var body: Optional<String>
    var retweet: Optional<Retweet>

    // always
    var timestamp: UInt64

    init?(json: Data) {
        let decoder = JSONDecoder()
        guard let content: Self = try? decoder.decode(PhoenixMessageContents.self, from: json) else {
            return nil
        }
        contents = content.contents
        body = content.body
        retweet = content.retweet
        timestamp = content.timestamp
    }
}

struct ReceivedMessage : Codable {
    var contents_hash: String
    var created_at: Int64
    var public_key: String
    var raw_message: String
    var sign: String
}
