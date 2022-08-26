//
// Created by Sumito Izumita on 2022/08/26.
//

import SwiftUI

class ServerPreferenceUseCase : ObservableObject {
    var model: ServerPreferenceModel
    private var repository: ServerRepository

    init(model: ServerPreferenceModel) {
        self.model = model
        repository = .init(server: model.server)
    }

    func getServerInfo() {
        Task {
            let meta = await repository.fetchMeta()
            DispatchQueue.main.async {
                self.model.meta = meta
            }
        }
    }
}
