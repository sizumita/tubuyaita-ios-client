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
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isAddServerPresented = false
    
    @FetchRequest(entity: Server.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Server.address, ascending: true)])
    var servers: FetchedResults<Server>
    

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("サーバー一覧")) {
                    List {
                        ForEach(servers) { server in
                            NavigationLink {
                                Text("abc")
                                    .navigationTitle(server.address!)
                            } label: {
                                Text("サーバー\(server.address!)")
                            }
                        }.onDelete { offset in
                            offset.forEach { i in
                                viewContext.delete(servers[i])
                            }
                            try? viewContext.save()
                        }
                    }
                }
                Section(footer: Text("[サーバー一覧](https://google.com)から追加するサーバーを発見することができます")) {
                    Button("サーバー追加") {
                        isAddServerPresented.toggle()
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
        .sheet(isPresented: $isAddServerPresented) {
            AddServerView()
        }
    }
}

struct PreferenceView_Previews: PreviewProvider {
    @State static var isPresented = true
    static var previews: some View {
        PreferenceView(isPresented: $isPresented)
    }
}
