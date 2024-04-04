//
//  ImportWallerViewModel.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 28/03/2024.
//

import Foundation
import Combine

class ImportWalletViewModel {
    
    enum Input {
        case verifyAddress(address: String)
    }
    
    enum Output {
        case isValidAddress(isValid: Bool)
    }
    
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            switch input {
            case .verifyAddress(let address):
                self?.verifyAddress(address)
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    

    func isValidAddress(address: String) -> Bool {
        true
    }
    
    private func verifyAddress(_ address: String) {
        output.send(.isValidAddress(isValid: false))
    }
    
}
