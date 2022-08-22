//
//  AccountsView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/21.
//

import SwiftUI

struct AccountsView: View {
    var server: Server
    @FetchRequest
    var namedAccounts: FetchedResults<Account>
    @FetchRequest
    var unnamedAccounts: FetchedResults<Account>
    @State private var path: [Account] = []

    init(server: Server) {
        self.server = server
        self._namedAccounts = FetchRequest<Account>(entity: Account.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Account.name, ascending: true)], predicate: NSPredicate(format: "name != nil && server == %@", server))
        self._unnamedAccounts = FetchRequest<Account>(entity: Account.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Account.name, ascending: true)], predicate: NSPredicate(format: "name == nil && server == %@", server))
    }

    var body: some View {
        NavigationStack(path: $path) {
            Form {
                Section("名前設定済み") {
                    List(namedAccounts) { account in
                        NavigationLink(value: account) {
                            AccountLabelView(account: Binding(get: {
                                account
                            }, set: {x in}))
                        }
                    }
                }
                Section("名前なし") {
                    List(unnamedAccounts) { account in
                        NavigationLink(value: account) {
                            AccountLabelView(account: Binding(get: {
                                account
                            }, set: {x in}))
                        }
                    }
                }
            }.navigationTitle("アカウント一覧")
        }.navigationDestination(for: Account.self) { account in
            AccountDetailView(account: .init(get: {
                account
            }, set: { acc in }), path: $path)
        }
    }
}
