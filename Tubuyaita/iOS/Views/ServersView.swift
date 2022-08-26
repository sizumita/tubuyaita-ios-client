//
//  ServersView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/24.
//

import SwiftUI



struct ServersView: View {
    @StateObject var model: ServersModel
    @StateObject var useCase: ServersUseCase

    @FetchRequest(entity: Server.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Server.address, ascending: true)])
    var servers: FetchedResults<Server>

    init() {
        let serversModel = ServersModel()
        self._model = StateObject(wrappedValue: serversModel)
        self._useCase = StateObject(wrappedValue: ServersUseCase(model: serversModel))
    }

    var body: some View {
        GeometryReader { reader in
            NavigationStack {
                ScrollViewReader { proxy in
                    ScrollView([], showsIndicators: false) {
                        HStack {
                            ForEach(Array(servers.enumerated()), id: \.offset) { i, server in
                                ServerView(model: ServerModel(server: server))
                                        .id(i)
                                        .frame(width: reader.size.width, height: reader.size.height)
                                        .onAppear {
                                            if !servers.isEmpty {
                                                model.selectedServerIndex = 0
                                            }
                                        }
                            }
                        }
                                .onChange(of: model.selectedServerIndex) { (newValue: Int?) in
                                    useCase.updateServer(newValue: newValue, reader: reader, servers: servers)
                                }
                                .offset(x: model.offset)
                                .navigationBarTitleDisplayMode(.inline)
                                .navigationTitle(model.navigationTitle)
                                .edgesIgnoringSafeArea(.bottom)
                    }
                            .edgesIgnoringSafeArea(.bottom)
                }
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                ServerSelectMenuView(model: ServerSelectMenuModel(index: $model.selectedServerIndex))
                            }
                        }
            }
                    .frame(width: reader.size.width, height: reader.size.height)
                    .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct ServersView_Previews: PreviewProvider {
    static var previews: some View {
        ServersView()
    }
}
