//
//  RepositoryDetailStoreTests.swift
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

class RepositoryDetailStoreTests: XCTestCase {
    let disposeBag = DisposeBag()
    let scheduler = TestScheduler(initialClock: 0)
    
    lazy var store = RepositoryDetailViewController.Store(state: .init(repositoryData: repository), middleware: [createThunkMiddleware()])
    
    let repository = GitHubRepositoryData(id: 1,
                                          fullName: "apple/swift",
                                          owner: .init(avatarUrl: "url"),
                                          description: "リポジトリ説明",
                                          stargazersCount: 61196,
                                          watchersCount: 61196,
                                          language: "C++",
                                          forksCount: 9836,
                                          openIssuesCount: 6243)
    
    lazy var isFavoriteSpy = scheduler.createObserver(Bool.self)
    lazy var fullNameSpy = scheduler.createObserver(String.self)
    lazy var descriptionTextSpy = scheduler.createObserver(String?.self)
    lazy var languageSpy = scheduler.createObserver(String.self)
    lazy var stargazersCountSpy = scheduler.createObserver(String.self)
    lazy var watchersCountSpy = scheduler.createObserver(String.self)
    lazy var forksCountSpy = scheduler.createObserver(String.self)
    lazy var openIssuesCountSpy = scheduler.createObserver(String.self)
    lazy var avatarImageSpy = scheduler.createObserver(URL.self)
    
    override func setUp() {
        super.setUp()
        
        store.rx.isFavorite.drive(isFavoriteSpy).disposed(by: disposeBag)
        store.rx.fullName.drive(fullNameSpy).disposed(by: disposeBag)
        //store.rx.descriptionText.drive(descriptionTextSpy).disposed(by: disposeBag)
        store.rx.descriptionText.drive(descriptionTextSpy).disposed(by: disposeBag)
        store.rx.language.drive(languageSpy).disposed(by: disposeBag)
        store.rx.stargazersCount.drive(stargazersCountSpy).disposed(by: disposeBag)
        store.rx.watchersCount.drive(watchersCountSpy).disposed(by: disposeBag)
        store.rx.forksCount.drive(forksCountSpy).disposed(by: disposeBag)
        store.rx.openIssuesCount.drive(openIssuesCountSpy).disposed(by: disposeBag)
        store.rx.avatarImage.drive(avatarImageSpy).disposed(by: disposeBag)
    }
    
    func test_isFavorite() {
        scheduler.scheduleAt(10) {
            self.store.dispatch(FavoriteRepositoryDataThunkCreator.Action.additionalSuccess)
        }
        scheduler.scheduleAt(20) {
            self.store.dispatch(FavoriteRepositoryDataThunkCreator.Action.deletionSuccess)
        }
        scheduler.scheduleAt(30) {
            self.store.dispatch(FavoriteRepositoryDataThunkCreator.Action.changeFavorite(isFavorite: true))
        }
        scheduler.scheduleAt(40) {
            self.store.dispatch(FavoriteRepositoryDataThunkCreator.Action.changeFavorite(isFavorite: false))
        }
        scheduler.start()
        
        XCTAssertEqual(isFavoriteSpy.events, [
            .next(0, false),
            .next(10, true),
            .next(20, false),
            .next(30, true),
            .next(40, false)
        ])
    }
    
    func test_fullName() {
        XCTAssertEqual(fullNameSpy.events, [
            .next(0, "apple/swift")
        ])
    }
    
    func test_descriptionText() {
        XCTAssertEqual(descriptionTextSpy.events, [
            .next(0, "リポジトリ説明")
        ])
    }
    
    func test_language() {
        XCTAssertEqual(languageSpy.events, [
            .next(0, "C++")
        ])
    }
    
    func test_stargazersCount() {
        XCTAssertEqual(stargazersCountSpy.events, [
            .next(0, "61196")
        ])
    }
    
    func test_watchersCount() {
        XCTAssertEqual(watchersCountSpy.events, [
            .next(0, "61196")
        ])
    }
    
    func test_forksCount() {
        XCTAssertEqual(forksCountSpy.events, [
            .next(0, "9836")
        ])
    }
    
    func test_openIssuesCount() {
        XCTAssertEqual(openIssuesCountSpy.events, [
            .next(0, "6243")
        ])
    }
    
    func test_avatarImage() {
        XCTAssertEqual(avatarImageSpy.events, [
            .next(0, .init(string: "url")!)
        ])
    }
}
