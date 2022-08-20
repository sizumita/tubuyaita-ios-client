//
//  CreateMessageModel.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/19.
//

import Foundation
import SwiftUI
import Sodium
import Clibsodium
import CryptoKit

struct SendMessage : Codable {
    var publicKey: String
    var contents: String
    var sign: String
}

extension DataProtocol {
    var data: Data { .init(self) }
    var hexa: String { map { .init(format: "%02x", $0) }.joined() }
}


class CreateMessageModel : ObservableObject {
    @Published var text = ""
    @Binding var server: Server?
    
    @Published var isError = false
    @Published var errorMessage = ""
    
    private var sodium = Sodium()
    
    init(server: Binding<Server?>) {
        self._server = server
    }
    
    func send(account: AccountStore) async throws -> Bool {
        if text.isEmpty {
            isError = true
            errorMessage = "メッセージを入力してください"
            return false
        }
        if text.count > 2000 {
            isError = true
            errorMessage = "メッセージは2000文字以内にしてください"
            return false
        }

        let content = MessageContent(contents: nil, body: self.text, retweet: nil, timestamp: UInt64(NSDate().timeIntervalSince1970))
        let encoder = JSONEncoder()
        guard let jsonContent = try? encoder.encode(content) else {
           fatalError("Failed to encode to JSON.")
        }
        
        let contentHash = Array(SHA512.hash(data: jsonContent))
        
        var signedContent = Array<UInt8>(repeating: 0, count: 64)
        guard crypto_sign_detached(&signedContent, nil, contentHash, UInt64(contentHash.count), account.getSecretKey()!) == 0 else {
            return false
        }
        let parameters: [String: Any] = [
            "publicKey":account.publicKey!.hexa,
            "contents": String(data: jsonContent, encoding: .utf8)!,
            "sign": signedContent.data.hexa,
        ]
        
        // MARK: send http message
        let url = String(format: "http://%@:%d/api/v1/messages", server!.address!, server!.port)
        guard let serviceUrl = URL(string: url) else { return false }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return false
        }
        
        request.httpBody = httpBody
        request.timeoutInterval = 20
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                print("invalid response")
                return false
            }
            return response.statusCode <= 399
        } catch {
            return false
        }
    }
}
