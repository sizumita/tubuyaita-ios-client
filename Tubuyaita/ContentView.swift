//
//  ContentView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/18.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var account: AccountStore

    var body: some View {
        if account.publicKey == nil {
            RegisterView()
        } else {
            ZStack {
                #if os(iOS)
                TimeLineView()
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
