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
    case jupiterStation
    
    var url: String {
        switch self {
        case .solanaMain: return "https://api.mainnet-beta.solana.com?"
        case .helius: return "https://rpc-proxy.mairo-molina5.workers.dev/?"
        case .jupiterStation: return "https://price.jup.ag/v4/price?"
        }
    }
}

enum RPCMethods {
    case getAccountInfo(String)
    case getAssetsByOwner(String)
    case getBalance(String)
    case getSolanaPrice
    case getSignaturesForAddress(String)
    case getTransactionDetail(String)
    
    var urlParams: String {
        switch self {
        case .getSolanaPrice: return "ids=SOL"
        default: return ""
        }
    }
    
    var bodyParams: [String: Any] {
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
        case .getAssetsByOwner(let address):
            let params: [String : Any] = [
                "jsonrpc": "2.0",
                "id": 1,
                "method": "getAssetsByOwner",
                "params": [
                    "ownerAddress": address,
                    "page": 1,
                    "limit": 1000,
                    "displayOptions": [
                        "showFungible": true
                    ]
                ]
            ]
            return params
        case .getBalance(let address):
            let params: [String : Any] = [
                "jsonrpc": "2.0", 
                "id": 1,
                "method": "getBalance",
                "params": [
                    address
                ]
            ]
            return params
        case .getSignaturesForAddress(let address):
            let params: [String : Any] = [
                "jsonrpc": "2.0",
                "id": 1,
                "method": "getSignaturesForAddress",
                "params": [
                    address,
                    [
                        "limit": 50
                    ]
                ]
            ]
            return params
        case .getTransactionDetail(let address):
            let params: [String : Any] = [
                "jsonrpc": "2.0",
                "id": 1,
                "method": "getTransaction",
                "params": [
                    address,
                  ["maxSupportedTransactionVersion": 0]
                ]
              ]
            return params
        default: return [:]
        }
    }
    
    var HTTPMethod: String {
        switch self {
        case .getAccountInfo(_), .getAssetsByOwner(_), .getBalance(_), .getSignaturesForAddress(_), .getTransactionDetail(_):
            return "POST"
        default:
            return "GET"
        }
    }
    
    func buildRequest(node: Node) -> URLRequest? {
        guard let url = URL(string: node.url + self.urlParams),
              let jsonData = try? JSONSerialization.data(withJSONObject: self.bodyParams)
        else { return nil }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = self.HTTPMethod
        
        if !self.bodyParams.isEmpty {
            request.httpBody = jsonData
        }
        
        return request
    }
}
