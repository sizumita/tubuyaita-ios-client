//
//  TimeLineView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/19.
//

import SwiftUI


extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else {
            return self
        }
        return String(self.dropFirst(prefix.count))
    }
}


struct TimeLineView: View {
    @StateObject var model: TimeLineModel
    @StateObject var useCase: TimeLineUseCase

    init(server: Server) {
        let timeLineModel = TimeLineModel(server: server)
        _model = StateObject(wrappedValue: timeLineModel)
        _useCase = StateObject(wrappedValue: TimeLineUseCase(model: timeLineModel))
    }

    var body: some View {
        Group {
            ZStack {
                if model.status == .connected {
                    List {
                        // Websocket経由で受け取ったメッセージ。最古->最新
                        ForEach(model.receivedMessages.reversed()) { message in
                            TweetView(message: message)
                                    .swipeActions(edge: .trailing) {
                                        NavigationLink {
                                            MessageDetailView(
                                                    message: Binding<TubuyaitaMessage>.init(get: { message }, set: { m, t in }))
                                        } label: {
                                            Image(systemName: "info.circle")
                                                    .foregroundColor(.red)
                                        }
                                    }
                        }
                        // HTTP経由で取得したメッセージ。最新->最古
                        ForEach(model.fetchedMessages) { message in
                            TweetView(message: message)
                                    .swipeActions(edge: .trailing) {
                                        NavigationLink {
                                            MessageDetailView(
                                                    message: Binding<TubuyaitaMessage>.init(get: { message }, set: { m, t in }))
                                        } label: {
                                            Image(systemName: "info.circle")
                                                    .foregroundColor(.red)
                                        }
                                    }
                        }
                        Button {
                            useCase.loadHistory()
                        } label: {
                            Text("メッセージを読み込む")
                        }
                    }
                            .listStyle(.plain)
                } else {
                    VStack {
                        if model.status == .error {
                            VStack {
                                Image(systemName: "wifi.exclamationmark")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 200, height: 200)
                                Text("接続できませんでした。")
                                        .bold()
                                        .font(.headline)
                                        .padding()
                                Button(action: {
                                    useCase.reconnect()
                                }, label: {
                                    Text("再接続")
                                            .bold()
                                })
                            }
                        } else {
                            Spinner()
                        }
                    }
                }
            }
                    .onAppear {
                        if model.status == .unconnected {
                            useCase.initialize()
                        }
                    }
                    .onDisappear {
                        useCase.disconnect()
                    }
        }
                .navigationTitle(model.server.address!)
    }
}
