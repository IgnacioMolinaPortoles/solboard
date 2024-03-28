//
//  PersistenceProtocol.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 28/03/2024.
//

import Foundation

protocol UserPersistenceProtocol {
    associatedtype DataType
    
    func getUser() -> DataType?
    func create(address: String) -> Bool
    func delete(id: UUID) -> Bool
    func update(item: DataType, newAddress: String) -> Bool
}
