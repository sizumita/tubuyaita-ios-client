//
//  NewMessageButtonView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/24.
//

import SwiftUI

struct NewMessageButtonView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "paperplane.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.accentColor)
                }
                Spacer()
            }.padding(.bottom, 80)
        }
    }
}

struct NewMessageButtonView_Previews: PreviewProvider {
    static var previews: some View {
        NewMessageButtonView()
    }
}
