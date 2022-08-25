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


class TimeLineModel : ObservableObject {
    var server: Server
    /// Websocket経由で受け取ったメッセージ。最古->最新
    @Published var fetchedMessages: [TubuyaitaMessage] = []
    /// HTTP経由で取得したメッセージ。最新->最古
    @Published var receivedMessages: [TubuyaitaMessage] = []
    @Published var isInitialized = false
    
    init(server: Server) {
        self.server = server
    }
}
