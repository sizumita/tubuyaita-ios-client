//
//  TimeLineView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/19.
//

import SwiftUI

struct TimeLineView: View {
    @StateObject var model: TimeLineModel

    var body: some View {
        ZStack {
            if model.messages.count == 0 {
                Text("メッセージがありません")
            } else {
                List {
                    ForEach(model.messages.reversed()) { msg in
                        TweetView(message: msg)
                            .swipeActions(edge: .trailing) {
                                NavigationLink {
                                    Text("av")
                                } label: {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.red)
                                }
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    
                                } label: {
                                    Image(systemName: "return")
                                }
                            }
                    }
                }
            }
        }
        .navigationTitle(Text(model.server.address!))
        .listStyle(.grouped)
        .onAppear() {
            model.onAppear()
        }
        .onDisappear() {
            model.onDisapper()
        }
    }
}
