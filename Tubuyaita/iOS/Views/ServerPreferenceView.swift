//
// Created by Sumito Izumita on 2022/08/26.
//

import SwiftUI

struct ServerPreferenceView : View {
    @StateObject var model: ServerPreferenceModel
    @StateObject var useCase: ServerPreferenceUseCase

    init(server: Server) {
        let preferenceModel = ServerPreferenceModel(server: server)
        self._model = StateObject(wrappedValue: preferenceModel)
        self._useCase = StateObject(wrappedValue: .init(model: preferenceModel))
    }

    var body: some View {
        Form {
            VStack {
                HStack {
                    Spacer()
                    if model.meta?.iconUrl != nil {
                        AsyncImage(url: URL(string: model.meta!.iconUrl)!, content: { (image: Image) in
                            image
                                    .resizable()
                                    .clipShape(Circle())
                                    .scaledToFit()
                                    .frame(width: 64, height: 64)
                        }, placeholder: {
                            Circle()
                                    .frame(width: 64, height: 64)
                        })
                    } else {
                        Circle()
                                .frame(width: 64, height: 64)
                    }
                    Spacer()
                }
                Text(model.meta?.name ?? model.server.address!)
                        .bold()
                        .font(.headline)
                if model.meta?.name != nil {
                    Text(model.server.address!)
                            .font(.caption)
                            .bold()
                            .foregroundColor(.gray)
                }
            }
                    .padding()
                    .foregroundColor(.clear)
            Section(header: Text("サーバー情報")) {
                Text("IPアドレス: \(model.server.address!)")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                Text("ポート番号: \(String(model.server.port))")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
            }
        }
                .navigationTitle(model.meta?.name ?? model.server.address!)
                .onAppear {
                    useCase.getServerInfo()
                }
    }
}
