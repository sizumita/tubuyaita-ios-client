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

    func loadHistory() {
        Task {
            await loadOldMessages()
        }
    }

    /// Load old messages
    /// - Parameter n: message count
    /// - Parameter cursor: Cursor
    private func loadOldMessages(_ n: Int = 100) async {
        var cursor: Cursor?
        if !model.fetchedMessages.isEmpty {
            cursor = .init(t: model.fetchedMessages.last!.timestamp.toUnixTimeMilliseconds(), v: 1, h: model.fetchedMessages.last!.id)
        }
        switch await repository.fetchMessages(server: model.server, cursor: cursor) {
        case .success(let messages):
            DispatchQueue.main.async {
                self.model.fetchedMessages.append(contentsOf: messages)
            }
        case .failure(let err):
            break
        }
    }

    private func initializeMessages() {
        Task {
            await loadOldMessages()
            DispatchQueue.main.async {
                self.model.isInitialized = true
            }
        }
    }
}
