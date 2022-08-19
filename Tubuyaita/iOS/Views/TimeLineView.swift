//
//  TimeLineView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/18.
//

import SwiftUI

struct TimeLineView: View {
    @State private var isSettingPresented = false
    @State var messages = [Server: [Message]]()
    
    @FetchRequest(entity: Server.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Server.address, ascending: true)])
    var servers: FetchedResults<Server>

    var body: some View {
        NavigationStack {
            List {
                ForEach(1..<100) { i in
                    TweetView(message: .init())
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
            }.listStyle(.grouped)
            .navigationBarTitle(Text("つぶやいたー"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        ForEach(1..<5) { i in
                            Button("\(i)") {
                                
                            }
                        }
                        Button("設定") {
                            isSettingPresented.toggle()
                        }
                    } label: {
                        Image(systemName: "globe")
                            .scaleEffect(1.2)
                    }
                }
            }
        }.fullScreenCover(isPresented: $isSettingPresented) {
            PreferenceView(isPresented: $isSettingPresented)
        }
    }
}

struct TimeLineView_Previews: PreviewProvider {
    static var previews: some View {
        TimeLineView()
    }
}
