//
//  TimeLineView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/18.
//

import SwiftUI

struct TimeLinesView: View {
    @FetchRequest(entity: Server.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Server.address, ascending: true)])
    var servers: FetchedResults<Server>
    @StateObject var model: TimeLinesModel = TimeLinesModel()

    var body: some View {
        NavigationStack {
            ZStack {
                if model.selectedServer != nil {
                    TabView {
                        TimeLineView(model: TimeLineModel.init(server: model.selectedServer!)).tabItem {
                            Image(systemName: "bubble.left.fill")
                        }
                        Text("ユーザー一覧")
                            .tabItem {
                                Image(systemName: "person.circle.fill")
                            }
                    }.navigationTitle(model.selectedServer?.address ?? "サーバーを選択してください")
                    VStack {
                        Spacer()
                        HStack {
                            Button {
                                model.isCreateMessagePresented.toggle()
                            } label: {
                                Image(systemName: "paperplane.circle.fill")
                                    .resizable()
                                    .frame(width: 64, height: 64)
                                    .foregroundColor(.accentColor)
                            }.padding(.bottom, 32)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        ForEach(servers) { server in
                            Button(server.address!) {
                                model.changeSelectedServer(server: server)
                            }
                        }
                        Button("設定") {
                            model.isSettingPresented.toggle()
                        }
                    } label: {
                        Image(systemName: "globe")
                            .scaleEffect(1.2)
                    }
                }
            }
        }.fullScreenCover(isPresented: $model.isSettingPresented) {
            PreferenceView(isPresented: $model.isSettingPresented)
        }
        .onAppear() {
            model.changeSelectedServer(server: servers.first)
        }
        .sheet(isPresented: $model.isCreateMessagePresented) {
            CreateMessageView(model: .init(server: model.selectedServer))
        }
        .onDisappear() {
            model.onDisappear()
        }
    }
}
