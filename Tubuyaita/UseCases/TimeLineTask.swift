//
//  TimeLineTask.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/24.
//

import Foundation
import SwiftUI
import Combine

class TimeLineTask : ObservableObject {
    var model: TimeLineModel
    private var repository: TimeLineRepository
    private var cancel: AnyCancellable?

    init(model: TimeLineModel) {
        self.model = model
        repository = .init()
    }

    func initialize() {
        cancel = repository.messageSubject.sink { message in
            DispatchQueue.main.async {
                self.model.receivedMessages.append(message)
            }
        }
        repository.connect(server: model.server)
        initializeMessages()
    }

    func disconnect() {
        cancel?.cancel()
    }

    /// Load old messages
    /// - Parameter n: message count
    func loadOldMessages(_ n: Int = 100) {

    }

    private func initializeMessages() {
        loadOldMessages()
        model.isInitialized = true
    }
}
