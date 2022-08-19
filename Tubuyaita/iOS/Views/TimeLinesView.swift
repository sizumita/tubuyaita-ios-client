//
//  TimeLineView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/18.
//

import SwiftUI

struct TimeLinesView: View {
    @State private var isSettingPresented = false
    @EnvironmentObject var account: AccountStore
    @ObservedObject var connections: Connections = Connections()
    
    @FetchRequest(entity: Server.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Server.address, ascending: true)])
    var servers: FetchedResults<Server>

    @State var selectedServer: Server?

    var body: some View {
        NavigationStack {
            ZStack {
                ForEach(servers) { server in
                    if server == selectedServer {
                        TimeLineView(server: server, reciever: $connections.recivers[server])
                            .onDisappear() {
                                print("disapper")
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
                                if connections.recivers[server] == nil {
                                    connections.recivers[server] = MessageReciver(url: "ws://\(server.address!):\(server.port)/socket", superCls: connections)
                                    connections.recivers[server]?.connect()
                                }
                                selectedServer = server
                            }
                        }
                        Button("設定") {
                            isSettingPresented.toggle()
                        }
                    } label: {
                        Image(systemName: "globe")
                            .scaleEffect(1.2)
                    }
                }
            }
        }.fullScreenCover(isPresented: $isSettingPresented) {
            PreferenceView(isPresented: $isSettingPresented)
        }
        .onAppear() {
            if servers.first != nil {
                let server = servers.first!
                if connections.recivers[server] == nil {
                    connections.recivers[server] = MessageReciver(url: "ws://\(server.address!):\(server.port)/socket", superCls: connections)
                    connections.recivers[server]?.connect()
                }
                selectedServer = servers.first
            }
        }
    }
}

struct TimeLineView_Previews: PreviewProvider {
    static var previews: some View {
        TimeLinesView()
    }
}
