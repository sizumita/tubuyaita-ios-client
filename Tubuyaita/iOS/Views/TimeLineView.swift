//
//  TimeLineView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/18.
//

import SwiftUI

struct TimeLineView: View {
    @State private var isSettingPresented = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(1..<100) { i in
                    NavigationLink("\(i)") {
                        Text("\(i)")
                    }
                }
            }
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
                        Image(systemName: "server.rack")
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
