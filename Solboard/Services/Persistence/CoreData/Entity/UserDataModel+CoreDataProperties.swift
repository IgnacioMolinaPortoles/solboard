//
//  UserDataModel+CoreDataProperties.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 28/03/2024.
//
//

import Foundation
import CoreData


extension UserDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDataModel> {
        return NSFetchRequest<UserDataModel>(entityName: "UserDataModel")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var address: String?

}

extension UserDataModel : Identifiable {

}
