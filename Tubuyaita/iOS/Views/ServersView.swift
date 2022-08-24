//
//  ServersView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/24.
//

import SwiftUI

struct ServersView: View {
    @StateObject var model = ServersModel()

    @FetchRequest(entity: Server.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Server.address, ascending: true)])
    var servers: FetchedResults<Server>

    var body: some View {
        NavigationStack(path: $model.path) {
            List {
                ForEach(servers) { server in
                    NavigationLink(value: server) {
                        Text(server.address!)
                    }
                }
            }
            .navigationTitle("サーバー一覧")
            .navigationDestination(for: Server.self) { server in
                ServerView(model: ServerModel(server: server, path: $model.path))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        model.isCreateServerPresented.toggle()
                    } label: {
                        Text("追加")
                            .bold()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        model.isPreferencePresented.toggle()
                    } label: {
                        Text("設定")
                            .bold()
                    }
                }
            }
        }
        .sheet(isPresented: $model.isCreateServerPresented) {
            AddServerView()
        }
        .fullScreenCover(isPresented: $model.isPreferencePresented) {
            PreferenceView()
        }
    }
}

struct ServersView_Previews: PreviewProvider {
    static var previews: some View {
        ServersView()
    }
}
