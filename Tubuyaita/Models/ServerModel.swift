//
//  ServerModel.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/24.
//

import Foundation
import SwiftUI


class ServerModel : ObservableObject {
    var server: Server
    @Published var tab: Int = 0
    var ts: Int

    init(server: Server) {
        self.server = server
        self.ts = Int.random(in: 0...100)
    }
}
