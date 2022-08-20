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
    
    @EnvironmentObject var account: AccountStore

    @Published var selectedServer: Server?
}
