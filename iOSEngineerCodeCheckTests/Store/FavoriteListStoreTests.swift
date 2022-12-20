//
//  FavoriteListStoreTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 杉岡成哉 on 2022/12/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

@testable import iOSEngineerCodeCheck
import XCTest
import RxTest
import RxSwift
import ReSwiftThunk

class FavoriteListStoreTests: XCTestCase {
    let disposeBag = DisposeBag()
    let scheduler = TestScheduler(initialClock: 0)
    
    let store = FavoriteListViewController.Store(state: nil, middleware: [createThunkMiddleware()])
    
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
    
    lazy var sectionsSpy = scheduler.createObserver([FavoriteListViewController.SectionModel].self)
    lazy var shouldHideEmptyViewSpy = scheduler.createObserver(Bool.self)
    lazy var shouldHideTableViewSpy = scheduler.createObserver(Bool.self)
    
    override func setUp() {
        super.setUp()
        
        store.rx.sections.drive(sectionsSpy).disposed(by: disposeBag)
        store.rx.shouldHideEmptyView.drive(shouldHideEmptyViewSpy).disposed(by: disposeBag)
        store.rx.shouldHideTableView.drive(shouldHideTableViewSpy).disposed(by: disposeBag)
    }
    
    func test_sections() {
        scheduler.scheduleAt(10) {
            self.store.dispatch(FavoriteRepositoryDataThunkCreator.Action.getSuccess(repositorys: .init([self.repository1, self.repository2])))
        }
        scheduler.scheduleAt(20) {
            self.store.dispatch(FavoriteRepositoryDataThunkCreator.Action.getSuccess(repositorys: .init([self.repository1])))
        }
        scheduler.start()
        
        XCTAssertEqual(sectionsSpy.events, [
            .next(0, [
                .init(items: [])
            ]),
            .next(10, [
                .init(items: [repository1, repository2])
            ]),
            .next(20, [
                .init(items: [repository1])
            ])
        ])
    }
    
    func test_shouldHideEmptyView() {
        scheduler.scheduleAt(10) {
            self.store.dispatch(FavoriteRepositoryDataThunkCreator.Action.getSuccess(repositorys: .init([self.repository1])))
        }
        scheduler.scheduleAt(20) {
            self.store.dispatch(FavoriteRepositoryDataThunkCreator.Action.getSuccess(repositorys: .init([])))
        }
        scheduler.start()
        
        XCTAssertEqual(shouldHideEmptyViewSpy.events, [
            .next(0, false),
            .next(10, true),
            .next(20, false)
        ])
    }
    
    func test_shouldHideTableView() {
        scheduler.scheduleAt(10) {
            self.store.dispatch(FavoriteRepositoryDataThunkCreator.Action.getSuccess(repositorys: .init([self.repository1])))
        }
        scheduler.scheduleAt(20) {
            self.store.dispatch(FavoriteRepositoryDataThunkCreator.Action.getSuccess(repositorys: .init([])))
        }
        scheduler.start()
        
        XCTAssertEqual(shouldHideTableViewSpy.events, [
            .next(0, true),
            .next(10, false),
            .next(20, true)
        ])
    }
}
