//
// Created by Sumito Izumita on 2022/08/26.
//

import SwiftUI

class ServerPreferenceModel : ObservableObject {
    var server: Server
    @Published var meta: ServerMeta?

    init(server: Server) {
        self.server = server
    }
}
