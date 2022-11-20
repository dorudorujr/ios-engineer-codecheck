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
        let root = UIViewController()
        window.rootViewController = root
        window.makeKeyAndVisible()

        let coordinator = RepositoryListCoordinator()
        coordinator.start(with: root)
        repositoryListCoordinator = coordinator
    }
}
