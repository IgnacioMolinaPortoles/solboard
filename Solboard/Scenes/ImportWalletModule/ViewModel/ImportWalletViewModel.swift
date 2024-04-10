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
    
    private let validatorService: ValidatorServiceProtocol
    
    init(validatorService: ValidatorServiceProtocol) {
        self.validatorService = validatorService
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
    
    private func verifyAddress(_ address: String) {
        validatorService.isValidAddress(address) { [output] isValid in
            output.send(.isValidAddress(isValid: isValid))
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
