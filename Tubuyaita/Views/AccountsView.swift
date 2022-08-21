//
//  AccountsView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/21.
//

import SwiftUI

struct AccountsView: View {
    var server: Server
    @FetchRequest(entity: Account.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Account.name, ascending: true)])
    var accounts: FetchedResults<Account>
    @State private var account: Account?

    var body: some View {
        NavigationSplitView {
            List(accounts, selection: $account) { account in
                NavigationLink(value: account) {
                    Text(account.name ?? account.publicKey!)
                }
            }.navigationTitle("アカウント一覧")
        } detail: {
            if account != nil {
                AccountDetailView(account: .init(get: {
                    account!
                }, set: { acc in
                    account = acc
                }))
            } else {
                Text("アカウントを選択してください")
            }
        }.onAppear() {
            accounts.nsPredicate = NSPredicate(format: "server == %@", server)
        }
    }
}
