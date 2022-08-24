//
//  ServerSelectMenuView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/24.
//

import SwiftUI

struct ServerSelectMenuView: View {
    @StateObject var model: ServerSelectMenuModel
    @EnvironmentObject var router: RouterNavigationPath
    
    @FetchRequest(entity: Server.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Server.address, ascending: true)])
    var servers: FetchedResults<Server>

    var body: some View {
        Menu {
            ForEach(servers) { server in
                Button {
                    // NOTE: ここでServerViewのWebsocketを消し飛ばしたい
                    router.path.append(.server(server))
                } label: {
                    Text(server.address!)
                }
                .disabled(model.server == server)
            }
            Button {
                router.path.removeLast(router.path.count)
            } label: {
                Text("サーバー一覧")
            }
        } label: {
            Image(systemName: "globe")
        }
    }
}
