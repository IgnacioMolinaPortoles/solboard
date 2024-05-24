//
//  DataManagerMock.swift
//  SolboardTests
//
//  Created by Ignacio Molina Portoles on 28/03/2024.
//

import Foundation
import CoreData

@testable import Solboard

class UserDataManagerMock: UserPersistenceProtocol {
    typealias DataType = UserDataModel
    
    var hasUser: Bool
    
    init(hasUser: Bool) {
        self.hasUser = hasUser
    }
    
    func getUser() -> UserDataModel? {
        if hasUser {
            let user = UserDataModel(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
            user.id = UUID()
            user.address = "solana1111"
            return user
        }
        return nil
    }
    
    func create(address: String) -> Bool {
        return hasUser
    }
    
    func delete(item: UserDataModel) -> Bool {
        return hasUser
    }
    
    func update(item: UserDataModel, newAddress: String) -> Bool {
        return hasUser
    }
}
