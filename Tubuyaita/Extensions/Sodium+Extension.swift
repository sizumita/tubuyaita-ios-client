//
//  Sodium+Extension.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/21.
//

import Foundation
import Sodium
import Clibsodium

extension Sodium {
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

    func signVerifyDetached(publicKey: Bytes, sign: Bytes, message: Data) -> Bool {
        guard message.withUnsafeBytes({ p in
            crypto_sign_verify_detached(sign, p, UInt64(message.count), publicKey)
        }) == 0 else {
            return false
        }
        return true
    }
}
