//
//  Coordinator.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 26/03/2024.
//

import Foundation
import UIKit
import CoreData

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
