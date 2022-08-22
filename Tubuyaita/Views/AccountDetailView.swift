//
//  AccountDetailView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/21.
//

import SwiftUI

struct AccountDetailView: View {
    @Binding var account: Account
    @State private var edited = false
    @State private var name: String = ""
    @State private var iconUrl: String = ""
    @Binding var path: [Account]
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        Form {
            Section("基本情報") {
                TextField("アカウント名", text: $name)
                TextField("アイコンURL", text: $iconUrl)
                ShareLink("公開鍵: 0x\(account.publicKey!)", item: "0x\(account.publicKey!)")
            }
//            Section {
//                Button {
//                    // MARK: まだこの機能はリリースしていない
//                } label: {
//                    Label("ユーザー情報を自動取得する", systemImage: "cloud.fill")
//                }
//            } footer: {
//                Text("まちカドネットワーク Identify Serverからユーザー情報を自動で取得します。")
//            }
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
            iconUrl = account.iconUrl?.absoluteString ?? ""
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("保存") {
                    account.name = name == "" ? nil : name
                    account.iconUrl = URL(string: iconUrl)
                    try? viewContext.save()
                    edited = false
                    path.removeAll()
                }.disabled(!edited)
            }
        }
        .navigationTitle(Text(account.name ?? "0x\(account.publicKey!.prefix(16))..."))
        .onChange(of: name) { newValue in
            if newValue != account.name ?? "" {
                edited = true
            }
        }
        .onChange(of: iconUrl) { newValue in
            if URL(string: newValue) != account.iconUrl {
                edited = true
            }
        }
    }
}
