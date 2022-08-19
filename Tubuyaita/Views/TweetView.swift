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
                }.frame(width: 50).padding(.trailing, 10).padding(.top)
                Grid {
                    GridRow {
                        Text("@abc")
                            .padding(.top, 3)
                            .bold().gridColumnAlignment(.leading)
                        Text("abc")
                            .font(.caption)
                            .gridCellAnchor(.bottom).padding(.bottom, 1)
                            .foregroundColor(.gray)
                    }.padding(.top, 10)
                        .padding(.bottom, 2)
                    GridRow {
                        Text("初めて呟きます！aaa初めて呟きます！aaa初めて呟きます！aaa初めて呟きます！aaa初めて呟きます！aaa初めて呟きます！aaa初めて呟きます！aaa")
                            .gridCellColumns(3)
                    }
                    Spacer()
                }
            }
        }.frame(minHeight: 100)
    }
}

struct TweetView_Previews: PreviewProvider {
    static var previews: some View {
        TweetView(message: .init())
    }
}
