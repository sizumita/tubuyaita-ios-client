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

    init(server: Server) {
        self.server = server
    }
}
