//
//  RepositoryListCoordinator.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/20.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit
import ReSwiftThunk

class RepositoryListCoordinator: TopCoordinator {
    private weak var repositoryDetailCoordinator: RepositoryDetailCoordinatyor?
    
    private(set) weak var viewController: RepositoryListViewController?
    
    init() {}
    
    func make() {
        let vc = StoryboardScene.RepositoryList.initialScene.instantiate(with: (
            store: .init(state: nil, middleware: [createThunkMiddleware()]),
            coordinator: self,
            requestThunkCreator: .init(request: .init(SearchGitHubRepositoryRequest()))
        ))
        viewController = vc
    }
}

extension RepositoryListCoordinator: RepositoryListCoordinatorDelegate {
    func showDetail(with repositoryData: GitHubRepositoryData) {
        let coordinator = RepositoryDetailCoordinatyor(repositoryData: repositoryData)
        guard let viewController = viewController else { return }
        coordinator.start(with: viewController)
        repositoryDetailCoordinator = coordinator
    }
}
