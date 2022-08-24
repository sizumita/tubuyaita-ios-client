//
//  PreferenceView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/18.
//

import SwiftUI
import CoreData

struct PreferenceView: View {
    @Environment(\.presentationMode) var presentation
    
    @EnvironmentObject var account: AccountStore
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isAddServerPresented = false
    
    @FetchRequest(entity: Server.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Server.address, ascending: true)])
    var servers: FetchedResults<Server>
    

    var body: some View {
        NavigationStack {
            Form {
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
                        presentation.wrappedValue.dismiss()
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
        PreferenceView()
    }
}
