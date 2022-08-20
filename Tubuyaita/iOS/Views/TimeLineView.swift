//
//  TimeLineView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/19.
//

import SwiftUI

extension Date {
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

struct TimeLineView: View {
    @StateObject var model: TimeLineModel
    
    @FetchRequest(
        entity: Server.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Server.address, ascending: false)],
        animation: .default
    )
    var servers: FetchedResults<Server>

    var body: some View {
        ZStack {
            if servers.first?.messages?.count == 0 {
                Text("メッセージがありません")
            } else {
                List {
                    ForEach((servers.first?.messages?.sortedArray(using: [NSSortDescriptor(keyPath: \Message.timestamp, ascending: false)]) ?? []) as! [Message]) { msg in
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
            servers.nsPredicate = NSPredicate(format: "address == %@", model.server.address!)
        }
    }
}
