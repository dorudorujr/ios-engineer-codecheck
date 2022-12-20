//
//  ApplicationCoordinator.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/21.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit

class ApplicationCoordinator {
    private weak var repositoryListCoordinator: RepositoryListCoordinator?
    
    func start(with window: UIWindow) {
        let root = UITabBarController()
        let repositoryListCoordinator = RepositoryListCoordinator()
        let favoriteListCoordinator = FavoriteListCoordinator()
        repositoryListCoordinator.make()
        favoriteListCoordinator.make()
        guard let repositoryListVC = repositoryListCoordinator.viewController,
              let favoriteListVC = favoriteListCoordinator.viewController else { return }
        repositoryListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        favoriteListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        
        let repositoryListNC = UINavigationController(rootViewController: repositoryListVC)
        repositoryListNC.modalPresentationStyle = .fullScreen
        
        let favoriteListNC = UINavigationController(rootViewController: favoriteListVC)
        favoriteListNC.modalPresentationStyle = .fullScreen
        
        root.viewControllers = [repositoryListNC, favoriteListNC]
        window.rootViewController = root
        window.makeKeyAndVisible()

        self.repositoryListCoordinator = repositoryListCoordinator
    }
}
