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
                ForEach(servers) { server in
                    if server == model.selectedServer {
                        TimeLineView(model: TimeLineModel.init(server: server))
                    }
                }
                if model.selectedServer != nil {
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
            CreateMessageView(model: .init(server: $model.selectedServer))
        }
        .onDisappear() {
            model.onDisappear()
        }
    }
}
