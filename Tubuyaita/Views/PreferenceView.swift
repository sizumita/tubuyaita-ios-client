//
//  PreferenceView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/18.
//

import SwiftUI

struct PreferenceView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var account: AccountStore
    

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
                        AccountStore().createAccount()
                    }
                }
                Section(header: Text("現在のアカウント")) {
                    ShareLink("公開鍵: \(account.getHexPublicKey() ?? "")", item: account.getHexPublicKey() ?? "")
                    ShareLink("秘密鍵をコピー", item: account.getHexSecretKey() ?? "")
                            .foregroundColor(.red)
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
