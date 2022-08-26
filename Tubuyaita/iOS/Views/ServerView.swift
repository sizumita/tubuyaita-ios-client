//
//  ServerView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/24.
//

import SwiftUI
import UIKit

struct ServerView: View {
    @StateObject var model: ServerModel

    var body: some View {
        ZStack {
            TabView(selection: $model.tab) {
                TimeLineView(server: model.server)
                        .tabItem {
                            Image(systemName: "bubble.left.fill")
                        }
                        .tag(0)
                AccountsView(server: model.server)
                        .tabItem {
                            Image(systemName: "person.circle.fill")
                        }
                        .tag(1)
            }
            if model.tab == 0 {
                NewMessageButtonView()
            }
        }
    }
}
