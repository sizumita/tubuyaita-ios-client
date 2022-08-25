//
//  TimeLineView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/19.
//

import SwiftUI


extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}


struct TimeLineView: View {
    @StateObject var model: TimeLineModel
    @StateObject var task: TimeLineTask

    init(server: Server) {
        let timeLineModel = TimeLineModel(server: server)
        _model = StateObject(wrappedValue: timeLineModel)
        _task = StateObject(wrappedValue: TimeLineTask(model: timeLineModel))
    }

    var body: some View {
        Group {
            ZStack {
                if model.isInitialized {
                    List {
                        // Websocket経由で受け取ったメッセージ。最古->最新
                        ForEach(model.receivedMessages.reversed()) { message in
                            TweetView(message: message)
                        }
                        // HTTP経由で取得したメッセージ。最新->最古
                        ForEach(model.fetchedMessages) { message in
                            Text(message.parsedContent)
                        }
                    }.listStyle(.plain)
                } else {
                    Spinner()
                }
            }
            .onAppear {
                print("aaa")
                task.initialize()
            }
                    .onDisappear {
                        task.disconnect()
                    }
        }
        .navigationTitle(model.server.address!)
    }
}
