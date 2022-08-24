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
    @Published var messages: [TubuyaitaMessage] = []
    @Published var isInitialized = false
    
    init(server: Server) {
        self.server = server
    }
}
