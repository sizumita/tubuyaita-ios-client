//
//  ServersView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/24.
//

import SwiftUI

enum Path: Hashable {
    case server(Server)
    case account(Account)
}

final class RouterNavigationPath: ObservableObject {
    @Published var path: [Path] = []
}

struct ServersView: View {
    @StateObject var model = ServersModel()
    @ObservedObject var router: RouterNavigationPath = .init()

    @FetchRequest(entity: Server.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Server.address, ascending: true)])
    var servers: FetchedResults<Server>
    
    @State private var path: [Account] = []


    var body: some View {
        NavigationStack(path: $router.path) {
            List {
                ForEach(servers) { server in
                    NavigationLink(value: Path.server(server)) {
                        Text(server.address!)
                    }
                }
            }
            .navigationTitle("サーバー一覧")
            .navigationDestination(for: Path.self) { path in
                switch path {
                case let .account(account):
                    AccountDetailView(model: .init(account: .init(get: {account}, set: {a in})))
                case let .server(server):
                    ServerView(model: ServerModel(server: server))
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                ServerSelectMenuView(model: .init(server: Binding(get: {server}, set: {s in })))
                            }
                        }
                }
            }
            .toolbar {
                toolbar
            }
        }
        .sheet(isPresented: $model.isCreateServerPresented) {
            AddServerView()
        }
        .fullScreenCover(isPresented: $model.isPreferencePresented) {
            PreferenceView()
        }
        .environmentObject(router)
    }
    
    var toolbar: some ToolbarContent {
        Group {
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
}

struct ServersView_Previews: PreviewProvider {
    static var previews: some View {
        ServersView()
    }
}
