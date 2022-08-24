//
//  ServerSelectMenuView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/24.
//

import SwiftUI

struct ServerSelectMenuView: View {
    @ObservedObject var model: ServerSelectMenuModel
    
    @FetchRequest(entity: Server.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Server.address, ascending: true)])
    var servers: FetchedResults<Server>

    var body: some View {
        Menu {
            ForEach(servers) { server in
                Button {
                    model.path.append(server)
                } label: {
                    Text(server.address!)
                }
                .disabled(model.path.last == server)
            }
            Button {
                model.path.removeAll()
            } label: {
                Text("サーバー一覧")
            }
        } label: {
            Image(systemName: "globe")
        }
    }
}

struct ServerSelectMenuView_Previews: PreviewProvider {
    @State static var path: [Server] = []
    static var previews: some View {
        ServerSelectMenuView(model: ServerSelectMenuModel.init(path: $path))
    }
}
