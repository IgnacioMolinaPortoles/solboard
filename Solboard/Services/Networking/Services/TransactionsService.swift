//
//  TransactionsService.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 14/04/2024.
//

import Foundation

protocol TransactionsServiceProtocol {
    func getSignatures(_ address: String, completion: @escaping ([TransactionViewModel]) -> Void)
}

class TransactionsService: TransactionsServiceProtocol {
    
    private let client: HTTPClient
    
    init(client: HTTPClient = URLSession.shared) {
        self.client = client
    }
    
    func getSignatures(_ address: String, completion: @escaping ([TransactionViewModel]) -> Void) {
        let request = RPCMethods.getSignaturesForAddress(address).buildRequest(node: .solanaMain)!
        
        client.perform(request, timeout: 10.0) { jsonData, response, error in
            guard let jsonData else {
                completion([])
                return
            }
            
            let response = try? JSONDecoder().decode(GetSignaturesResponse.self, from: jsonData)
            let parsedData = TransactionMapper.map(response)
            DispatchQueue.main.async {
                completion(parsedData)
            }
        }
    }
}

struct TransactionMapper {
    static func map(_ response: GetSignaturesResponse?) -> [TransactionViewModel] {
        var transactions: [TransactionViewModel] = []
        
        response?.result?.forEach({ signature in
            transactions.append(
                TransactionViewModel(signatureHash: signature.signature ?? "",
                                     unixDate: signature.blockTime ?? 0)
            )
        })
        
        return transactions
    }
}
