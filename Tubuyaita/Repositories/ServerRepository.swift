//
// Created by Sumito Izumita on 2022/08/26.
//

import Foundation


class ServerRepository {
    private var server: Server

    init(server: Server) {
        self.server = server
    }

    func fetchMeta() async -> ServerMeta? {
        let url = URL(string: String(format: "http://%@:%d/api/v1/meta", server.address!, server.port))!

        guard let (data, response) = try? await URLSession.shared.data(from: url) else {
            return nil
        }
        let decoder = JSONDecoder()
        guard var meta: ServerMeta = try? decoder.decode(ServerMeta.self, from: data) else {
            return nil
        }
        return meta
    }
}
