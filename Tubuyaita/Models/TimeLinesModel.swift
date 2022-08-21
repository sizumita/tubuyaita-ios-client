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
    @Published var selectedTab: Int = 0

    @EnvironmentObject var account: AccountStore

    @Published var selectedServer: Server?
    
    func changeSelectedServer(server: Server?) {
        if server != nil {
            if connections[server!] == nil {
                connections[server!] = PhoenixConnection(server: server!)
                connections[server!]?.connect()
            }
        }
        selectedServer = server
    }
    
    func onDisappear() {
        connections.forEach { (_, v) in
            v.disconnect()
        }
    }
}
