//
//  TweetView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/19.
//

import SwiftUI

struct TweetView: View {
    @State var message: Message

    var body: some View {
        Grid {
            GridRow {
                VStack {
                    Circle()
                    Spacer()
                }.padding(.top)
                    .gridCellAnchor(.leading)
                    .gridCellColumns(1)
                VStack {
                    HStack {
                        Text("@abcd")
                            .font(.headline)
                        Text(message.publicKey.prefix(16) + "...")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                    }.frame(alignment: .leading)
                    HStack {
                        Text(message.content)
                        Spacer(minLength: 0)
                    }
                        .gridCellColumns(2)
                        .gridCellAnchor(.leading)
                }.gridCellAnchor(.topLeading)
                    .padding(.top)
                    .padding(.trailing, 3)
                    .gridCellColumns(5)
            }
        }.frame(minHeight: 100)
    }
}

struct TweetView_Previews: PreviewProvider {
    static var previews: some View {
        TweetView(message: .init(id: "6516e3f1621169f12c0bba18c16f054a27d2c8230ab7a6550658a02ee1439fb6", content: "テストだよ！", publicKey: "6516e3f1621169f12c0bba18c16f054a27d2c8230ab7a6550658a02ee1439fb6", sign: "900b76c770bfa8f74afc375088e732607b868aa868cefd2a3560922ac23df9c97448d2200a31094b76b1681e92d5a391c7ce558552d2223d7265d3e3c0a9dd0f"))
    }
}
