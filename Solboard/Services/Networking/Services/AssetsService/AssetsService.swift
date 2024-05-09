//
//  AssetsService.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 11/04/2024.
//

import Foundation

protocol AssetsServiceProtocol {
    func getAddressAssets(_ address: String, completion: @escaping (AssetByOwnerResponse?) -> Void)
    func getSolanaPrice(completion: @escaping (Double) -> Void)
    func getBalance(_ address: String, completion: @escaping (Double) -> Void)
}
    
final class AssetsService: AssetsServiceProtocol {
    private let client: HTTPClient
    
    init(client: HTTPClient = URLSession.shared) {
        self.client = client
    }
    
    func getBalance(_ address: String, completion: @escaping (Double) -> Void) {
        guard let request = RPCMethods.getBalance(address).buildRequest(node: .helius) else {
            completion(0.0)
            return
        }
        
        client.perform(request, timeout: 10) { jsonData, response, error in
            guard let jsonData else {
                completion(0.0)
                return
            }
            
            let response = try? JSONDecoder().decode(GetBalanceResponse.self, from: jsonData)
            
            if let solBalance = response?.result?.value {
                completion(Double(Double(solBalance) / Constants.lamports))
            } else {
                completion(0.0)
            }
        }
    }
    
    func getSolanaPrice(completion: @escaping (Double) -> Void) {
        guard let request = RPCMethods.getSolanaPrice.buildRequest(node: .jupiterStation) else {
            completion(0.0)
            return
        }
        
        client.perform(request, timeout: 10) { jsonData, response, error in
            guard let jsonData else {
                completion(0.0)
                return
            }
            
            let response = try? JSONDecoder().decode(SolanaPriceResponse.self, from: jsonData)
            completion(response?.data?.sol?.price ?? 0.0)
        }
    }
    
    func getAddressAssets(_ address: String, completion: @escaping (AssetByOwnerResponse?) -> Void) {
        guard let request = RPCMethods.getAssetsByOwner(address).buildRequest(node: Node.helius) else {
            completion(nil)
            return
        }
        
        client.perform(request, timeout: TimeInterval(floatLiteral: 10.0)) { jsonData, response, error  in
            guard let jsonData else {
                completion(nil)
                return
            }
            do {
                let assetWelcome = try JSONDecoder().decode(AssetByOwnerResponse.self, from: jsonData)
                completion(assetWelcome)
            } catch(_) {
                completion(nil)
            }
        }
    }
}
