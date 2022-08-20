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
import Clibsodium

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
    
    func getSecretKey() -> Bytes? {
        if publicKey == nil {
            return nil
        }
        var b = Bytes()
        b.append(contentsOf: keychain[data: "secretKey"]!)
        return b
    }

    func createAccount() {
        var pk = Bytes(repeating: 0, count: 32)
        var sk = Bytes(repeating: 0, count: 64)
        guard crypto_sign_ed25519_keypair(&pk, &sk) == 0 else {
            return
        }
        print(pk)
        keychain[data: "secretKey"] = Data(bytes: sk, count: sk.count)
        keychain[data: "publicKey"] = Data(bytes: pk, count: pk.count)
        updatePublicKey()
    }
    
    func updatePublicKey() {
        self.publicKey = keychain[data: "publicKey"]
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    func createCurvePublicKey(pk: Data) -> Bytes? {
        var curve25519PublicKey = Bytes(repeating: 0, count: 32)
        guard pk.withUnsafeBytes { p in
            guard crypto_sign_ed25519_pk_to_curve25519(&curve25519PublicKey, p) == 0 else {
                return 1
            }
            return 0
        } == 0 else {
            return nil
        }
        return curve25519PublicKey
    }
    
    func createCurveSecretKey(sk: Data) -> Bytes? {
        var curve25519SecretKey = Bytes(repeating: 0, count: 32)
        guard sk.withUnsafeBytes({ sk in
            guard crypto_sign_ed25519_sk_to_curve25519(&curve25519SecretKey, sk) == 0 else {
                return 1
            }
            return 0
        }) == 0 else {
            return nil
        }
        return curve25519SecretKey
    }

    func boxWithCurve(message: Bytes, pk: Bytes) -> Bytes? {
        return sodium.box.seal(message: message, recipientPublicKey: pk)
    }
    
    init() {
        updatePublicKey()
    }
}

extension AccountStore {
    func verifyContent(publicKey: String, sign: String, message: Data) -> Bool {
        let publicKey = sodium.utils.hex2bin(publicKey)
        let sign = sodium.utils.hex2bin(sign)
        if publicKey == nil || sign == nil {
            return false
        }

        guard message.withUnsafeBytes({ p in
            crypto_sign_verify_detached(sign!, p, UInt64(message.count), publicKey!)
        }) == 0 else {
            return false
        }
        return true
    }
}
