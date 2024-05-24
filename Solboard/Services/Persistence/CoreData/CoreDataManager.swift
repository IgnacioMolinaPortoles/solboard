//
//  CoreDataManager.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 28/03/2024.
//

import Foundation
import CoreData

class UserCoreDataManager: UserPersistenceProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getUser() -> UserDataModel? {
        do {
            let users = try context.fetch(DataType.fetchRequest()) as? [UserDataModel]
            return users?.first
        } catch {
            return nil
        }
    }
    
    func create(address: String) -> Bool {
        do {
            let users = try context.fetch(DataType.fetchRequest()) as? [UserDataModel]
            
            if (users?.filter({ $0.address == address }))?.isEmpty ?? false {
                let newItem = UserDataModel(context: self.context)
                newItem.id = UUID()
                newItem.address = address
                
                try self.context.save()
                return true
            }
            return true
        } catch {
            return false
        }
    }
    
    func delete(item: UserDataModel) -> Bool {        
        do {
            self.context.delete(item)
            
            try self.context.save()
            return true
        } catch {
            return false
        }
    }
    
    func update(item: UserDataModel, newAddress: String) -> Bool {
        do {
            item.address = newAddress
            
            try self.context.save()
            return true
        } catch {
            return false
        }
    }
    

}
