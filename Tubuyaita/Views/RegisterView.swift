//
//  RegisterView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/19.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var account: AccountStore

    var body: some View {
        NavigationStack {
            Button("アカウント作成") {
                account.createAccount()
            }
                .navigationTitle("アカウント作成")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
