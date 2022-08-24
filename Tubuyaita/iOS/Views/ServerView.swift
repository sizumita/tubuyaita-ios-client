//
//  ServerView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/24.
//

import SwiftUI

struct ServerView: View {
    @StateObject var model: ServerModel

    var body: some View {
        TabView {
            Text("abc").tabItem {
                Image(systemName: "bubble.left.fill")
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle(model.server.address!)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                ServerSelectMenuView(model: .init(path: $model.path))
            }
        }
    }
}
