//
//  TweetView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/19.
//

import SwiftUI

struct TweetView: View {
    @Binding var message: Message
    @Binding var account: Account?
    @State var dateString: String?

    var body: some View {
        Grid {
            GridRow {
                VStack {
                    if account?.iconUrl != nil {
                        AsyncImage(url: account!.iconUrl) { image in
                            image
                                .resizable()
                                .clipShape(Circle())
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        } placeholder: {
                            Circle()
                                .frame(width: 50, height: 50)
                        }
                    } else {
                        Circle()
                            .frame(width: 50, height: 50)
                    }
                    Spacer()
                }.padding(.top)
                    .gridCellAnchor(.leading)
                    .gridCellColumns(1)
                VStack {
                    HStack {
                        if account?.name != nil {
                            Text("@\(account!.name!)")
                                .font(.headline)
                                .bold()
                            Text(message.publicKey!.prefix(16) + "...")
                                .font(.caption)
                                .foregroundColor(.gray)
                        } else {
                            Text("@0x" + message.publicKey!.prefix(16) + "...")
                                .font(.headline)
                                .bold()
                        }
                        Spacer(minLength: 0)
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
