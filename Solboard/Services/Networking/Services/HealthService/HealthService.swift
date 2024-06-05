//
//  HealthService.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 24/05/2024.
//

import Foundation

struct GenesisHashResponse: Decodable {
    let jsonrpc: String?
    let result: String?
    let id: Int?
}

enum APIStatus {
    case avaliable
    case unavailable(String)
}

protocol HealthServiceProtocol {
    func getStatus(completion: @escaping (APIStatus) -> Void)
}

class HealthService: HealthServiceProtocol {
    
    let client: HTTPClient
    
    init(client: HTTPClient = URLSession.shared) {
        self.client = client
    }
    
    
    func getStatus(completion: @escaping (APIStatus) -> Void) {
        guard let request = RPCMethods.getGenesisHash.buildRequest(node: .helius) else {
            DispatchQueue.main.async {
                completion(.unavailable("Invalid request"))
            }
            return
        }
        
        client.perform(request, timeout: 10.0) { data, response, error in
            DispatchQueue.main.async {
                if let error {
                    completion(.unavailable(error.localizedDescription))
                    return
                }
                
                guard let data else {
                    completion(.unavailable("No data"))
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(GenesisHashResponse.self, from: data)
                    
                    if let hash = response.result, hash.count > 1 {
                        completion(.avaliable)
                    } else {
                        completion(.unavailable("No data"))
                    }
                } catch let error {
                    completion(.unavailable(error.localizedDescription))
                }
            }
        }
    }
}
