//
//  SceneDelegate.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 3/11/24.
//

import UIKit
import Factory

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = PresentationFactory.createMainViewController()
        window?.makeKeyAndVisible()
    }
}
