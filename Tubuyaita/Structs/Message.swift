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

    var account: Account
}
