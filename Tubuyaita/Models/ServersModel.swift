//
//  ServersModel.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/24.
//

import Foundation
import SwiftUI

class ServersModel : ObservableObject {
    @Published var path: [Server] = []
}
