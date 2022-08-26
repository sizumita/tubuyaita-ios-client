//
//  ServerSelectMenuModel.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/24.
//

import Foundation
import SwiftUI

class ServerSelectMenuModel : ObservableObject {
    @Binding var selectedServerIndex: Int?
    @Published var isPreferencePresented = false
    
    init(index: Binding<Int?>) {
        self._selectedServerIndex = index
    }
}
