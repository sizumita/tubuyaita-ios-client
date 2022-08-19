//
//  Account.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/19.
//

import Foundation
import KeychainAccess
import Sodium
import SwiftUI

class AccountStore : ObservableObject {
    private let keychain = Keychain(service: "com.sumidora.Tubuyaita").synchronizable(true)
    let sodium = Sodium()
    var publicKey: Data?
    
    func getHexPublicKey() -> String? {
        if publicKey == nil {
            return nil
        }
        var b = Bytes()
        b.append(contentsOf: publicKey!)
        return sodium.utils.bin2hex(b)
    }
    
    func getHexSecretKey() -> String? {
        if publicKey == nil {
            return nil
        }
        var b = Bytes()
        b.append(contentsOf: keychain[data: "secretKey"]!)
        return sodium.utils.bin2hex(b)
    }

    func createAccount() {
        let pair = sodium.sign.keyPair()!
        keychain[data: "secretKey"] = Data(bytes: pair.secretKey, count: pair.secretKey.count)
        keychain[data: "publicKey"] = Data(bytes: pair.publicKey, count: pair.secretKey.count)
        updatePublicKey()
    }
    
    func updatePublicKey() {
        self.publicKey = keychain[data: "publicKey"]
        self.objectWillChange.send()
    }
    
    init() {
        updatePublicKey()
    }
}
