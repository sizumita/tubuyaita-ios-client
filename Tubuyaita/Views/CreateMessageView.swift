//
//  CreateMessageView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/19.
//

import SwiftUI

struct CreateMessageView: View {
    @ObservedObject var model: CreateMessageModel
    @EnvironmentObject var account: AccountStore
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @FocusState var focusField: Bool

    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    HStack {
                        Circle()
                            .frame(width: 24, height: 24)
                        Text("@Sumidora").bold().font(.subheadline)
                        Spacer()
                    }
                    TextField("なにがしたい？", text: $model.text, axis: .vertical)
                        .focused($focusField, equals: true)
                        .onAppear() {
                            focusField = true
                        }
                    Spacer()
                }.padding(.horizontal)
                    .padding(.top, 5)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("キャンセル")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            send()
                        } label: {
                            Text("つぶやく")
                                .bold()
                        }
                        .disabled(model.text == "")
                    }
                }
            }
        }
    }
    
    func send() {
        Task {
            let r = try? await model.send(account: account)
            if r == nil {
                return
            }
            if r! {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
