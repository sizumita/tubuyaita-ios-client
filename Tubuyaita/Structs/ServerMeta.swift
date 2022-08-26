//
// Created by Sumito Izumita on 2022/08/26.
//

import Foundation


struct ServerMeta : Codable {
    var administrator: String
    var iconUrl: String
    var name: String

    enum CodingKeys : String, CodingKey {
        case iconUrl = "icon_url", administrator, name
    }
}
