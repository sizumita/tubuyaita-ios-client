//
//  AccountDetailView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/21.
//

import SwiftUI

struct AccountDetailView: View {
    @StateObject var model: AccountDetailModel
    @State private var edited = false
    @State private var name: String = ""
    @State private var iconUrl: String = ""
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        Form {
            Section("基本情報") {
                TextField("アカウント名", text: $name)
                TextField("アイコンURL", text: $iconUrl)
                ShareLink("公開鍵: 0x\(model.account.publicKey!)", item: "0x\(model.account.publicKey!)")
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
            name = model.account.name ?? ""
            iconUrl = model.account.iconUrl?.absoluteString ?? ""
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("保存") {
                    model.account.name = name == "" ? nil : name
                    model.account.iconUrl = URL(string: iconUrl)
                    try? viewContext.save()
                    edited = false
                }.disabled(!edited)
            }
        }
        .navigationTitle(Text(model.account.name ?? "0x\(model.account.publicKey!.prefix(16))..."))
        .onChange(of: name) { newValue in
            if newValue != model.account.name ?? "" {
                edited = true
            }
        }
        .onChange(of: iconUrl) { newValue in
            if URL(string: newValue) != model.account.iconUrl {
                edited = true
            }
        }
    }
}
