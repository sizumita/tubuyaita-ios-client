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
    
    var SelectMenu: some View {
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

    var body: some View {
        NavigationStack {
            ZStack {
                if model.selectedServer != nil {
                    TabView(selection: $model.selectedTab) {
                        TimeLineView(model: TimeLineModel.init(server: model.selectedServer!))
                        .tabItem {
                            Image(systemName: "bubble.left.fill")
                        }.tag(0)
                        AccountsView(server: model.selectedServer!)
                        .tabItem {
                            Image(systemName: "person.circle.fill")
                        }.tag(1)
                    }.navigationTitle(model.selectedServer?.address ?? "サーバーを選択してください")
                    if model.selectedTab == 0 {
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
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    SelectMenu
                }
            }
        }.fullScreenCover(isPresented: $model.isSettingPresented) {
            PreferenceView()
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
