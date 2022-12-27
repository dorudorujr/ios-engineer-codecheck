//
//  FavoriteListViewControllerTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 杉岡成哉 on 2022/12/16.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

@testable import iOSEngineerCodeCheck
import XCTest
import iOSSnapshotTestCase
import Kingfisher

class FavoriteListViewControllerTests: FBSnapshotTestCase {
    let cacheDummyURL = "https://avatar/dummy/url"
    
    override func setUp() {
        super.setUp()
        recordMode = false
        fileNameOptions = [.screenSize, .screenScale]
        KingfisherManager.shared.cache.store(.init(systemName: "square.and.arrow.up")!, forKey: cacheDummyURL)
    }
    
    override func tearDown() {
        super.tearDown()
        KingfisherManager.shared.cache.removeImage(forKey: cacheDummyURL)
    }
    
    func test_exists() {
        let vc = StoryboardScene.FavoriteList.initialScene.instantiate(with: (store: .init(state: .init(repositorys: repositorys)),
                                                                              coordinator: FavoriteListCoordinator(),
                                                                              favoriteThunkCreator: .init(repository: FavoriteRepositoryDataRepositoryImpl())))
        verify(vc: vc)
    }
    
    func test_empty() {
        let vc = StoryboardScene.FavoriteList.initialScene.instantiate(with: (store: .init(state: nil),
                                                                              coordinator: FavoriteListCoordinator(),
                                                                              favoriteThunkCreator: .init(repository: FavoriteRepositoryDataRepositoryImpl())))
        verify(vc: vc)
    }
    
    private let repositorys: [GitHubRepositoryData] = [
        .init(id: 1,
              fullName: "apple/swift",
              owner: .init(avatarUrl: "https://avatar/dummy/url"),
              description: "リポジトリの説明",
              stargazersCount: 61196,
              watchersCount: 61196,
              language: "C++",
              forksCount: 9836,
              openIssuesCount: 6243),
        .init(id: 2,
              fullName: "tensorflow/swift",
              owner: .init(avatarUrl: "https://avatar/dummy/url"),
              description: "リポジトリの説明",
              stargazersCount: 6068,
              watchersCount: 6068,
              language: "Jupyter Notebook",
              forksCount: 623,
              openIssuesCount: 37)
    ]
}
