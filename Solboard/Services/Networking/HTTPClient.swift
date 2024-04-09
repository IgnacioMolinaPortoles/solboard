//
//  HTTPClient.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 03/04/2024.
//

import Foundation

enum HTTPError: Error {
    case nullResponse
}

protocol HTTPClient {
    func perform(_ request: URLRequest, timeout: TimeInterval, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void)
}

extension URLSession: HTTPClient {
    func perform(_ request: URLRequest, timeout: TimeInterval, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        dataTask(with: request) { data, urlResponse, error in
            guard let httpUrlRequest = urlResponse as? HTTPURLResponse else {
                completion(nil, nil, NSError(domain: "No http response", code: -1))
                return
            }
            
            completion(data, httpUrlRequest, nil)
        }.resume()
    }
}

enum Node {
    case solanaMain
    case helius
    
    var url: String {
        switch self {
        case .solanaMain: return "https://api.mainnet-beta.solana.com"
        case .helius: return ""
        }
    }
}

enum RPCMethods {
    case getAccountInfo(String)
    
    var params: [String: Any] {
        switch self {
        case .getAccountInfo(let address):
            let params: [String : Any] = [
                "jsonrpc": "2.0",
                "id": 1,
                "method": "getAccountInfo",
                "params": [
                    address,
                    [
                        "encoding": "base58"
                    ]
                ]
            ]
            
            return params
        }
    }
    
    func buildRequest(node: Node) -> URLRequest? {
        switch self {
        case .getAccountInfo(_):
            guard let url = URL(string: node.url),
                  let jsonData = try? JSONSerialization.data(withJSONObject: self.params)
            else { return nil }
            
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = jsonData
            
            return request
        }
    }
}

protocol ValidatorServiceProtocol {
    func isValidAddress(_ address: String, completion: @escaping (Bool) -> Void)
}
    
final class ValidatorService: ValidatorServiceProtocol {
    private let client: HTTPClient
    
    init(client: HTTPClient = URLSession.shared) {
        self.client = client
    }
    
    func isValidAddress(_ address: String, completion: @escaping (Bool) -> Void) {
        guard let request = RPCMethods.getAccountInfo(address).buildRequest(node: Node.solanaMain) else {
                completion(false)
            return
        }
        
        client.perform(request, timeout: TimeInterval(floatLiteral: 10.0)) { data, response, error  in
            guard let data else {
                completion(false)
                return
            }
            let response = try? JSONDecoder().decode(GetAccountInfoResponse.self, from: data)
            
            completion(response?.result != nil)
        }
    }
}
