//
//  RepositoryListCoordinator.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/20.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryListCoordinator: Coordinator {
    private weak var viewController: RepositoryListViewController!
    private weak var repositoryDetailCoordinator: RepositoryDetailCoordinatyor?
    
    init() {}
    
    func start(with parent: UIViewController) {
        let vc = StoryboardScene.RepositoryList.initialScene.instantiate(with: (
            repository: .init(),
            coordinator: self
        ))
        let nc = UINavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen
        parent.present(nc, animated: false)
        viewController = vc
    }
}

extension RepositoryListCoordinator: RepositoryListCoordinatorDelegate {
    func showDetail(with repositoryData: GitHubRepositoryData) {
        let coordinator = RepositoryDetailCoordinatyor(repositoryData: repositoryData)
        coordinator.start(with: viewController)
        repositoryDetailCoordinator = coordinator
    }
}
