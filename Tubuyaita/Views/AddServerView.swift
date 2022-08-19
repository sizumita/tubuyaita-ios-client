//
//  AddServerView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/19.
//

import SwiftUI

struct AddServerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentation

    @State private var address: String = ""
    @State private var port: String = ""
    
    @State private var isError = false
    @State private var errorMessage = ""
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("アドレス", text: $address)
                    TextField("ポート番号", text: $port)
                        .keyboardType(.numberPad)
                }
                Button("作成") {
                    addServer()
                }
            }.navigationTitle("サーバー追加")
        }.alert(isPresented: $isError) {
            Alert(title: Text("エラーが発生しました"), message: Text(errorMessage))
        }
    }
    
    func addServer() {
        let p = Int32(port)
        if p == nil || p! < 1 || p! > 65535 {
            errorMessage = "ポート番号が不正です。1から25565までにしてください"
            isError = true
            return
        }
        if address == "" {
            errorMessage = "アドレスを入力してください"
            isError = true
            return
        }
        let server = Server(context: viewContext)
        server.address = address
        server.port = p!
        try? viewContext.save()
        presentation.wrappedValue.dismiss()
    }
}

struct AddServerView_Previews: PreviewProvider {
    static var previews: some View {
        AddServerView()
    }
}
