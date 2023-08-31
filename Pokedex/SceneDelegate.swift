//
//  SceneDelegate.swift
//  Pokedex
//
//  Created by 이은재 on 2023/08/31.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let pokedexService = PokedexService()
        let listVM = ListViewModel(pokedexService: pokedexService)
        let mainVC = ListViewController(viewModel: listVM)
        let nav = UINavigationController(rootViewController: mainVC)
        window.rootViewController = nav
        self.window = window
        
        window.makeKeyAndVisible()
        
    }
}

