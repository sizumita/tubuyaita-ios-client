//
//  ServerSelectMenuView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/24.
//

import SwiftUI

struct ServerSelectMenuView: View {
    @StateObject var model: ServerSelectMenuModel

    @FetchRequest(entity: Server.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Server.address, ascending: true)])
    var servers: FetchedResults<Server>

    var body: some View {
        Menu {
            ForEach(Array(servers.enumerated()), id: \.offset) { i, server in
                Button {
                    model.selectedServerIndex = i
                    let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
                    feedbackGenerator.impactOccurred()
                } label: {
                    Text(server.address!)
                }
                .disabled(model.selectedServerIndex == i)
            }
            Button(action: {
                model.isPreferencePresented.toggle()
            }, label: {
                Text("設定")
            })
        } label: {
            Image(systemName: "globe")
        }
                .sheet(isPresented: $model.isPreferencePresented) {
                    PreferenceView()
                }
    }
}
