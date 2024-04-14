//
//  ValidatorService.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 11/04/2024.
//

import Foundation

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
            
            DispatchQueue.main.async {
                completion(response?.result != nil)
            }
        }
    }
}

final class PersistenceDecoratorForValidatorService: ValidatorServiceProtocol {
    
    private let validatorService: ValidatorServiceProtocol
    private let coreDataManager: any UserPersistenceProtocol

    init(validatorService: ValidatorServiceProtocol, coreDataManager: any UserPersistenceProtocol) {
        self.validatorService = validatorService
        self.coreDataManager = coreDataManager
    }
    
    func isValidAddress(_ address: String, completion: @escaping (Bool) -> Void) {
        validatorService.isValidAddress(address) { [coreDataManager] isValid in
            if isValid {
                let saved = coreDataManager.create(address: address)
                completion(saved)
                return
            }
            
            completion(isValid)
        }
    }
}
