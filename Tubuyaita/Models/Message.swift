//
//  Message.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/19.
//

import Foundation

struct Message : Identifiable {
    // hex content_hash
    let id: String
    let content: String
    let publicKey: String
    let sign: String
}
