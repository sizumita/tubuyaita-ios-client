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
    @Binding var path: [Server]
    
    init(server: Server, path: Binding<[Server]>) {
        self.server = server
        self._path = path
    }
}
