//
//  Connections.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/19.
//

import Foundation
import SwiftUI
import KeychainAccess
import Sodium

class Connections : ObservableObject {
    @Published var recivers: [Server: MessageReciver] = [:]
    private let keychain = Keychain(service: "com.sumidora.Tubuyaita").synchronizable(true)
    let sodium = Sodium()

    @FetchRequest(entity: Server.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Server.address, ascending: true)])
    var servers: FetchedResults<Server>
}
