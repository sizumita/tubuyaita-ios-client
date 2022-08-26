//
// Created by Sumito Izumita on 2022/08/26.
//

import Foundation
import SwiftUI

class ServersUseCase : ObservableObject {
    private var model: ServersModel

    init(model: ServersModel) {
        self.model = model
    }

    func updateServer(newValue: Int?, reader: GeometryProxy, servers: FetchedResults<Server>) {
        if newValue != nil {
            withAnimation(.easeInOut(duration: 0.3)) {
                model.offset = -(CGFloat(newValue!) * reader.size.width)
            }
            model.navigationTitle = servers[newValue!].address!
        }
    }
}
