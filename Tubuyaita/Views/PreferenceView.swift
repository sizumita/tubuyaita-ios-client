//
//  PreferenceView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/18.
//

import SwiftUI
import CoreData

struct PreferenceView: View {
    @Binding var isPresented: Bool
    @Binding var selectedServer: Server?
    
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
                                Form {
                                    Section("設定") {
                                    }
                                }
                                    .navigationTitle(server.address!)
                            } label: {
                                Text(server.address!)
                            }
                        }.onDelete { offset in
                            offset.forEach { i in
                                selectedServer = nil
                                servers[i].accounts?.forEach({ elem in
                                    viewContext.delete(elem as! NSManagedObject)
                                })
                                servers[i].messages?.forEach({ elem in
                                    viewContext.delete(elem as! NSManagedObject)
                                })
                                servers[i].fetchHistories?.forEach({ elem in
                                    viewContext.delete(elem as! NSManagedObject)
                                })
                                viewContext.delete(servers[i])
                            }
                            try? viewContext.save()
                            // 終了しないとselectedServer = nilしたのにnilにassertion errorが出ちゃう
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                            }
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
                    Button("再生成") {
                        account.createAccount()
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
        .sheet(isPresented: $isAddServerPresented) {
            AddServerView()
        }
    }
}

struct PreferenceView_Previews: PreviewProvider {
    @State static var isPresented = true
    @State static var selectedServer: Server?
    static var previews: some View {
        PreferenceView(isPresented: $isPresented, selectedServer: $selectedServer)
    }
}
