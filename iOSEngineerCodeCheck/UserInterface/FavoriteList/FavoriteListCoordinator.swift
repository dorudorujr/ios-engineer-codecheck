//
//  FavoriteListCoordinator.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/12/10.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit
import ReSwiftThunk

class FavoriteListCoordinator: TopCoordinator {
    private weak var repositoryDetailCoordinator: RepositoryDetailCoordinatyor?
    
    private(set) weak var viewController: FavoriteListViewController?
    
    init() {}
    
    func make() {
        let vc = StoryboardScene.FavoriteList.initialScene.instantiate(with: (
            store: .init(state: nil, middleware: [createThunkMiddleware()]),
            coordinator: self
        ))
        viewController = vc
    }
}

extension FavoriteListCoordinator: FavoriteListCoordinatorDelegate {
    func showDetail(with repositoryData: GitHubRepositoryData) {
        let coordinator = RepositoryDetailCoordinatyor(repositoryData: repositoryData)
        guard let viewController = viewController else { return }
        coordinator.start(with: viewController)
        repositoryDetailCoordinator = coordinator
    }
}
