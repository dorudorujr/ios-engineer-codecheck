//
//  RepositoryListViewControllerSnapshotTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 杉岡成哉 on 2022/12/02.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//
@testable import iOSEngineerCodeCheck
import XCTest
import iOSSnapshotTestCase
import Kingfisher

class RepositoryListViewControllerSnapshotTests: FBSnapshotTestCase {
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
    
    func test_normal() {
        let request = RequestMock<SearchGitHubRepositoryParameter, RepositorySearchResponse>()
        let store = RxStore<RepositoryListState>(state: nil)
        store.dispatch(RepositoryListThunkCreator.Action.success(parameter: .init(searchWord: "searchWord"), response: .init(items: repositorys)))
        let vc = StoryboardScene.RepositoryList.initialScene.instantiate(with: (
            store: store,
            coordinator: RepositoryListCoordinator(),
            requestThunkCreator: .init(request: .init(request))))
        verify(vc: vc)
    }
    
    private let repositorys: [GitHubRepositoryData] = [
        .init(id: 1,
              fullName: "apple/swift",
              owner: .init(avatarUrl: "https://avatar/dummy/url"),
              description: "description",
              stargazersCount: 61196,
              watchersCount: 61196,
              language: "C++",
              forksCount: 9836,
              openIssuesCount: 6243),
        .init(id: 2,
              fullName: "tensorflow/swift",
              owner: .init(avatarUrl: "https://avatar/dummy/url"),
              description: "description",
              stargazersCount: 6068,
              watchersCount: 6068,
              language: "Jupyter Notebook",
              forksCount: 623,
              openIssuesCount: 37)
    ]
}
