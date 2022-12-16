//
//  RepositoryListStoreTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 杉岡成哉 on 2022/11/27.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//
@testable import iOSEngineerCodeCheck
import XCTest
import RxTest
import RxSwift
import ReSwiftThunk

class RepositoryListStoreTests: XCTestCase {
    let disposeBag = DisposeBag()
    let scheduler = TestScheduler(initialClock: 0)
    
    let store = RepositoryListViewController.Store(state: nil, middleware: [createThunkMiddleware()])
    
    lazy var sectionsSpy = scheduler.createObserver([RepositoryListViewController.SectionModel].self)
    
    override func setUp() {
        super.setUp()
        
        store.rx.sections.drive(sectionsSpy).disposed(by: disposeBag)
    }
    
    func test_sections() {
        let repository1 = GitHubRepositoryData(id: 1,
                                               fullName: "apple/swift",
                                               owner: .init(avatarUrl: "url"),
                                               stargazersCount: 61196,
                                               watchersCount: 61196,
                                               language: "C++",
                                               forksCount: 9836,
                                               openIssuesCount: 6243)
        let repository2 = GitHubRepositoryData(id: 2,
                                               fullName: "tensorflow/swift",
                                               owner: .init(avatarUrl: "url"),
                                               stargazersCount: 6068,
                                               watchersCount: 6068,
                                               language: "Jupyter Notebook",
                                               forksCount: 623,
                                               openIssuesCount: 37)
        
        scheduler.scheduleAt(10) {
            self.store.dispatch(RepositoryListThunkCreator.Action.success(parameter: .init(searchWord: "searchWord"), response: .init(items: [repository1, repository2])))
        }
        scheduler.scheduleAt(20) {
            self.store.dispatch(RepositoryListThunkCreator.Action.success(parameter: .init(searchWord: "searchWord"), response: .init(items: [repository1])))
        }
        scheduler.start()
        
        XCTAssertEqual(sectionsSpy.events, [
            .next(0, [
                .init(items: [])
            ]),
            .next(10, [
                .init(items: [repository1, repository2])
            ]),
            .next(20, [.init(items: [repository1])])
        ])
    }
}
