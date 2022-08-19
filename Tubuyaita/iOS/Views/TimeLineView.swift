//
//  TimeLineView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/19.
//

import SwiftUI

struct TimeLineView: View {
    var server: Server
    @Binding var reciever: MessageReciver?

    var body: some View {
        List {
            ForEach(reciever?.messages ?? []) { msg in
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
            .refreshable {
                print("abc")
            }
            TweetView(message: .init(id: "", content: "Beep, Beep. メッセージを送信したいときは右上のボタンから！", publicKey: "Admin", sign: ""))
        }
        .navigationTitle(Text(server.address!))
        .listStyle(.grouped)
    }
}
