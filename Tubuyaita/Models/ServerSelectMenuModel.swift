//
//  ServerSelectMenuModel.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/24.
//

import Foundation
import SwiftUI

class ServerSelectMenuModel : ObservableObject {
    @Binding var path: [Server]
    
    init(path: Binding<[Server]>) {
        self._path = path
    }
}
