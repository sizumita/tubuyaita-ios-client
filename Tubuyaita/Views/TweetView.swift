//
//  TweetView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/19.
//

import SwiftUI

struct TweetView: View {
    @State var message: Message
    @State var dateString: String?

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
                        Text(message.publicKey!.hexa.prefix(16) + "...")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                    }.frame(alignment: .leading)
                    HStack {
                        Text(message.parsedContent!)
                        Spacer(minLength: 0)
                    }
                        .gridCellColumns(2)
                        .gridCellAnchor(.leading)
                    Spacer(minLength: 0)
                    HStack {
                        Text(dateString ?? "")
                            .font(.caption2)
                            .bold()
                            .foregroundColor(.gray)
                        Spacer(minLength: 0)
                    }.gridCellAnchor(.leading)
                        .gridCellColumns(2)
                }.gridCellAnchor(.topLeading)
                    .padding(.top)
                    .padding(.trailing, 3)
                    .gridCellColumns(5)
            }
        }
            .onAppear() {
                let date = message.timestamp
                let df = DateFormatter()
                df.locale = .init(identifier: "ja_JP")
                df.dateFormat = "yyyy/MM/dd HH:mm:ss"
                dateString = df.string(from: date!)
            }
    }
}
