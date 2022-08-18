//
//  PreferenceView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/18.
//

import SwiftUI

struct PreferenceView: View {
    @Binding var isPresented: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("サーバー一覧")) {
                    List {
                        ForEach(1..<3) { i in
                            NavigationLink {
                                Text("abc")
                                    .navigationTitle("サーバー\(i)")
                            } label: {
                                Text("サーバー\(i)")
                            }
                        }.onDelete { i in
                            print(i)
                        }
                    }
                }
                Section(footer: Text("[サーバー一覧](https://google.com)から追加するサーバーを発見することができます")) {
                    Button("サーバー追加") {
                        
                    }
                }
                Section(header: Text("現在のアカウント")) {
                    ShareLink("公開鍵: ...", item: "...")
                    Button {
                        
                    } label: {
                        Label("秘密鍵を表示する", image: "exclamationmark.circle").foregroundColor(.red)
                    }
                    Menu {
                        ForEach(1..<3) { i in
                            Text("アカウント\(i)")
                        }
                    } label: {
                        Text("アカウント変更")
                    }
                }
                Section(header: Text("アカウント設定")) {
                    ForEach(1..<3) { i in
                        NavigationLink {
                            Text("abc")
                                .navigationTitle("アカウント\(i)")
                        } label: {
                            Text("アカウント\(i)")
                        }
                    }
                }
                Section() {
                    Button {
                        
                    } label: {
                        Text("アカウント追加")
                    }

                }
            }
            .navigationTitle("設定")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("閉じる") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

struct PreferenceView_Previews: PreviewProvider {
    @State static var isPresented = true
    static var previews: some View {
        PreferenceView(isPresented: $isPresented)
    }
}
