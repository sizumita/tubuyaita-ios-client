//
//  TimeLineModel.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/19.
//

import Foundation
import SwiftUI
import Combine

class TimeLineModel : ObservableObject {
    var server: Server

    init(server: Server) {
        self.server = server
    }
}
