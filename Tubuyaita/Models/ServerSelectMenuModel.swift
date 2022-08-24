//
//  ServerSelectMenuModel.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/24.
//

import Foundation
import SwiftUI

class ServerSelectMenuModel : ObservableObject {
    @Binding var server: Server
    
    init(server: Binding<Server>) {
        self._server = server
    }
}
