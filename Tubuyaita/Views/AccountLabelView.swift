//
//  AccountLabelView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/21.
//

import SwiftUI

struct AccountLabelView: View {
    @Binding var account: Account
    
    var body: some View {
        Grid {
            GridRow {
                VStack {
                    if account.iconUrl != nil {
                        AsyncImage(url: account.iconUrl) { image in
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
                        if account.name != nil {
                            Text("@\(account.name!)")
                                .font(.headline)
                                .bold()
                        } else {
                            Text("@0x" + account.publicKey!.prefix(16) + "...")
                                .font(.headline)
                                .bold()
                        }
                        Spacer()
                    }
                    HStack {
                        if account.name != nil {
                            Text("0x" + account.publicKey!.prefix(16) + "...")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                }.gridCellAnchor(.topLeading)
                    .padding(.top)
                    .padding(.trailing, 3)
                    .gridCellColumns(5)
                    .padding(.leading, 3)
            }
        }
    }
}
