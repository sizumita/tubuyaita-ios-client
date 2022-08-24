//
//  TimeLineTask.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/24.
//

import Foundation
import SwiftUI

class TimeLineTask : ObservableObject {
    @Published var model: TimeLineModel

    init(server: Server) {
        self.model = TimeLineModel(server: server)
    }

    /// Load old messages
    /// - Parameter n: message count
    func loadOldMessages(_ n: Int = 100) {

    }

    func initializeMessages() {
        loadOldMessages()
        model.isInitialized = true
    }
}
