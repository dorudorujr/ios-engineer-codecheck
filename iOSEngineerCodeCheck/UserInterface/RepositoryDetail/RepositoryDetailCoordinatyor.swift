//
//  RepositoryDetailCoordinatyor.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/20.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit
import ReSwiftThunk

class RepositoryDetailCoordinatyor: SecondaryCoordinator {
    private weak var viewController: RepositoryDetailViewController!
    private let repositoryData: GitHubRepositoryData

    init(repositoryData: GitHubRepositoryData) {
        self.repositoryData = repositoryData
    }

    func start(with parent: UIViewController) {
        let vc = StoryboardScene.RepositoryDetail.initialScene.instantiate(with: (
            store: .init(state: RepositoryDetailState(repositoryData: repositoryData),
                         middleware: [createThunkMiddleware()]),
            favoriteThunkCreator: .init(repository: FavoriteRepositoryDataRepositoryImpl())
        ))
        parent.navigationController?.pushViewController(vc, animated: true)
        viewController = vc
    }
}
