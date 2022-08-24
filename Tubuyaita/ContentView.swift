//
//  ContentView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/18.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var account: AccountStore

    var body: some View {
        if account.publicKey == nil {
            RegisterView()
        } else {
            ZStack {
                #if os(iOS)
                ServersView()
                #else
                Text("abc")
                #endif
            }
        }
    }
 
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
