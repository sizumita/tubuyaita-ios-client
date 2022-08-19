//
//  CreateMessageView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/19.
//

import SwiftUI

struct CreateMessageView: View {
    @State var server: Server
    @Binding var retweet: Retweet?
    
    @SwiftUI.Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State var text = ""
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
                    TextField("なにがしたい？", text: $text, axis: .vertical)
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
                            
                        } label: {
                            Text("つぶやく")
                                .bold()
                        }
                    }
                }
            }
        }
    }
}
