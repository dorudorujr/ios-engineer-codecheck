//
//  RepositoryDetailCoordinatyor.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/20.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryDetailCoordinatyor: Coordinator {
    private weak var viewController: RepositoryDetailViewController!
    private let repositoryData: GitHubRepositoryData

    init(repositoryData: GitHubRepositoryData) {
        self.repositoryData = repositoryData
    }

    func start(with parent: UIViewController) {
        let vc = StoryboardScene.RepositoryDetail.initialScene.instantiate(with: repositoryData)
        parent.navigationController?.pushViewController(vc, animated: true)
        viewController = vc
    }
}
