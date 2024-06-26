//
//  SceneDelegate.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 21/03/2024.
//

import UIKit
import CoreData
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var currentScene: UIWindowScene?
    var manteinanceView = UIHostingController(rootView: ManteinanceView())
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let uiWindowScene = (scene as? UIWindowScene) else { return }
        
        currentScene = uiWindowScene   
        
        guard let persistentContainer = UIApplication.appDelegate?.persistentContainer else { return }

        let userCoreDataManager = UserCoreDataManager(context: persistentContainer.viewContext)
        
        let loginCoordinator = LoginCoordinator(navigationController: UINavigationController(),
                                                dataManager: userCoreDataManager)
        
        let homeCoordinator = HomeCoordinator(navigationController: UINavigationController(),
                                              dataManager: userCoreDataManager)
        
        let presentationManager = PresentationManager(dataManager: userCoreDataManager,
                                                      loginCoordinator: loginCoordinator,
                                                      homeCoordinator: homeCoordinator)
        
        setRootViewController(presentationManager.getNavigation())
    }
    
    func setRootViewController(_ viewController: UIViewController) {
        guard let scene = currentScene else { return }
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = viewController
        window?.overrideUserInterfaceStyle = .dark
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        HealthService().getStatus { [weak self] apiStatus in
            switch apiStatus {
            case .avaliable:
                self?.manteinanceView.dismiss(animated: true)
            case .unavailable(let error):
                guard let manteinanceView = self?.manteinanceView else {
                    return
                }
                
                if self?.window?.rootViewController?.presentedViewController != manteinanceView {
                    manteinanceView.modalPresentationStyle = .overFullScreen
                    self?.window?.rootViewController?.present(manteinanceView, animated: true)
                }
            }
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

