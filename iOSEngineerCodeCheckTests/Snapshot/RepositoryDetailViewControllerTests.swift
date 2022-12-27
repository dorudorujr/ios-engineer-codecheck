//
//  RepositoryDetailViewControllerTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 杉岡成哉 on 2022/12/02.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

@testable import iOSEngineerCodeCheck
import XCTest
import iOSSnapshotTestCase
import Kingfisher
import RealmSwift

class RepositoryDetailViewControllerTests: FBSnapshotTestCase {
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
    
    func test_not_favorite() {
        let repository = GitHubRepositoryData(id: 1,
                                              fullName: "apple/swift",
                                              owner: .init(avatarUrl: cacheDummyURL),
                                              description: "リポジトリ説明",
                                              stargazersCount: 61196,
                                              watchersCount: 61196,
                                              language: "C++",
                                              forksCount: 9836,
                                              openIssuesCount: 6243)
        let vc = StoryboardScene.RepositoryDetail.initialScene.instantiate(
            with: (store: .init(state: .init(repositoryData: repository)),
                   favoriteThunkCreator: .init(repository: FavoriteRepositoryDataRepositoryImpl()))
        )
        verify(vc: vc)
    }
    
    func test_favorite() {
        let repository = GitHubRepositoryData(id: 1,
                                              fullName: "apple/swift",
                                              owner: .init(avatarUrl: cacheDummyURL),
                                              description: "リポジトリ説明",
                                              stargazersCount: 61196,
                                              watchersCount: 61196,
                                              language: "C++",
                                              forksCount: 9836,
                                              openIssuesCount: 6243)
        let favoriteRepository = FavoriteRepositoryDataRepositoryImpl()
        let vc = StoryboardScene.RepositoryDetail.initialScene.instantiate(
            with: (store: .init(state: .init(repositoryData: repository, isFavorite: true)),
                   favoriteThunkCreator: .init(repository: favoriteRepository))
        )
        verify(vc: vc)
    }
}

