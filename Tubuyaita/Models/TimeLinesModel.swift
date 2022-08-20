//
//  TimeLinesModel.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/19.
//

import Foundation
import SwiftUI

class TimeLinesModel : ObservableObject {
    @Published var isSettingPresented = false
    @Published var isCreateMessagePresented = false
    @Published var connections: [Server:PhoenixConnection] = [:]
    
    @EnvironmentObject var account: AccountStore

    @Published var selectedServer: Server?
    
    func changeSelectedServer(server: Server?) {
        if server != nil || connections[server!] == nil {
            connections[server!] = PhoenixConnection(server: server!)
            connections[server!]?.connect()
        }
        selectedServer = server
    }
    
    func onDisappear() {
        connections.forEach { (_, v) in
            v.disconnect()
        }
    }
}
