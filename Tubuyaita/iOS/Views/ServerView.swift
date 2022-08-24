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
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Menu {
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
    }
}
