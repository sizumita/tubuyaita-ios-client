//
//  AccountDetailView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/21.
//

import SwiftUI

struct AccountDetailView: View {
    @Binding var account: Account
    @State private var name: String = ""
    @State private var iconUrl: String = ""
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        Form {
            Section("基本情報") {
                TextField("アカウント名", text: $name)
                TextField("アイコンURL", text: $iconUrl)
            }
            Section {
                Button {
                    
                } label: {
                    Label("ユーザー情報を自動取得する", image: "cloud")
                }
            } footer: {
                Text("まちカドネットワーク Identify Serverからユーザー情報を自動で取得します。")
            }
            Section("危険な操作") {
                Button {
                    
                } label: {
                    Text("ブロックする")
                        .bold()
                        .foregroundColor(.red)
                }
                Button {
                    
                } label: {
                    Text("このユーザーを通報する")
                        .bold()
                        .foregroundColor(.red)
                }

            }

        }.onAppear() {
            name = account.name ?? ""
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("保存") {
                    account.name = name
                    try? viewContext.save()
                }
            }
        }
        .navigationTitle(Text(account.name ?? "\(account.publicKey!.prefix(16))..."))
    }
}
