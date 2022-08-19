//
//  TimeLineModel.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/19.
//

import Foundation
import SwiftUI
import Combine

class TimeLineModel : ObservableObject {
    var server: Server
    @Published var messages: [Message] = []
    
    private var connection: PhoenixConnection
    private var cancel: AnyCancellable?
    
    init(server: Server) {
        self.server = server
        self.connection = .init(url: "ws://\(server.address!):\(server.port)/socket")
    }
    
    func onAppear() {
        self.connection.connect()
        self.cancel = self.connection.subject.sink { msg in
            self.messages.append(msg)
        }
    }
    
    func onDisapper() {
        self.cancel?.cancel()
        self.connection.disconnect()
    }
}
