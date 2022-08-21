//
//  Date+Extension.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/21.
//

import Foundation

extension Date {
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    func toUnixTimeMilliseconds() -> Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}
