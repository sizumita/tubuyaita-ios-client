//
//  Message+Extension.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/21.
//

import Foundation
import CoreData

extension Message {
    convenience init(context: NSManagedObjectContext, server: Server, contentHash: Data, content: MessageContent, sign: Data, publicKey: String) {
        self.init(context: context)
        self.server = server
        self.contentHash = contentHash
        self.sign = sign
        self.publicKey = publicKey
        if content.contents != nil {
            // MARK: Crypto Message
            self.isContentEncrypted = false
            self.parsedContent = "Encrypted"
        } else {
            // MARK: Default Message
            self.isContentEncrypted = false
            self.parsedContent = content.body
        }
        // TODO: メンション確認
        self.isMentioned = false
        self.timestamp = Date(milliseconds: Int64(content.timestamp))
    }
}
