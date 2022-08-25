//
//  MessageDetailView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/22.
//

import SwiftUI

struct MessageDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FocusState var focus: Bool

    @Binding var message: TubuyaitaMessage

    @State var accountName = ""
    @State var accountIconUrl = ""
    @State var edited = false

    var body: some View {
        Form {
            Section {
                TweetView(message: message)
            }
            Section("アカウント") {
                TextField("名前", text: $accountName)
                    .focused($focus)
                TextField("アイコンURL", text: $accountIconUrl)
                    .focused($focus)
                ShareLink("公開鍵: 0x\(message.publicKey)", item: "0x\(message.publicKey)")
            }
//            Section {
//                Button {
//                    // MARK: 未リリース
//                } label: {
//                    Label("ユーザー情報を自動取得する", systemImage: "cloud.fill")
//                }
//            } footer: {
//                Text("まちカドネットワーク Identify Serverからユーザー情報を自動で取得します。")
//            }
            Section("操作") {
                Button(action: {}, label: {Text("メッセージを報告する").foregroundColor(.red).bold()})
                Button(action: {}, label: {Text("ユーザーをブロックする").foregroundColor(.red).bold()})
            }
        }
        .navigationTitle(message.account?.name ?? ("0x" + message.publicKey.prefix(16) + "..."))
        .onAppear() {
            accountName = message.account?.name ?? ""
            accountIconUrl = message.account?.iconUrl?.absoluteString ?? ""
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("保存") {
                    message.account?.name = accountName == "" ? nil : accountName
                    message.account?.iconUrl = URL(string: accountIconUrl)
                    try? viewContext.save()
                    edited = false
                }.disabled(!edited)
            }
            if focus {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        focus = false
                    }
                }
            }
        }
        .onChange(of: accountName) { newValue in
            if newValue != message.account?.name ?? "" {
                edited = true
            }
        }
        .onChange(of: accountIconUrl) { newValue in
            if URL(string: newValue) != message.account?.iconUrl {
                edited = true
            }
        }.navigationBarBackButtonHidden(focus)
    }
}
