//
//  TimeLineUseCase.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/24.
//

import Foundation
import SwiftUI
import Combine

class TimeLineUseCase : ObservableObject {
    private var model: TimeLineModel
    private var repository: TimeLineRepository
    private var cancels: [AnyCancellable] = []

    init(model: TimeLineModel) {
        self.model = model
        repository = .init()
    }

    func initialize() {
        let cancel = repository.messagePublisher().sink { message in
            DispatchQueue.main.async {
                self.model.receivedMessages.append(message)
            }
        }
        cancels.append(cancel)
        let cancel2 = repository.socketPublisher().sink { (status: SocketStatus) in
            switch status {
            case .connect:
                self.model.status = .connected
            case .disconnect:
                break
            case .error(let err):
                self.repository.disconnect()
                self.model.status = .error
            }
        }
        cancels.append(cancel2)
        repository.connect(server: model.server)
        model.status = .connecting
        initializeMessages()
    }

    func reconnect() {
        repository.connect(server: model.server)
        model.status = .connecting
        initializeMessages()
    }

    func disconnect() {
        cancels.map({c in c.cancel()})
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
        }
    }
}
