//
//  FavoriteRepositoryDataRepositoryTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 杉岡成哉 on 2022/12/18.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

@testable import iOSEngineerCodeCheck
import XCTest
import RealmSwift

class FavoriteRepositoryDataRepositoryTests: XCTestCase {
    lazy var realm = try! Realm(configuration: .init(inMemoryIdentifier: self.name))
    lazy var repository = FavoriteRepositoryDataRepositoryImpl(realm: realm)
    let repositoryData = GitHubRepositoryData(id: 1,
                                              fullName: "apple/swift",
                                              owner: .init(avatarUrl: "url"),
                                              stargazersCount: 61196,
                                              watchersCount: 61196,
                                              language: "C++",
                                              forksCount: 9836,
                                              openIssuesCount: 6243)
    
    override func setUp() {
        super.setUp()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func test_repositorys_add() {
        XCTAssertTrue(repository.repositorys().isEmpty)
        
        try! repository.add(repositoryData)
        
        XCTAssertEqual(repository.repositorys(), [repositoryData])
    }
    
    func test_delete() {
        try! repository.add(repositoryData)
        XCTAssertEqual(repository.repositorys(), [repositoryData])
        try! repository.delete(repositoryData)
        XCTAssertTrue(repository.repositorys().isEmpty)
    }
    
    func test_isFavorite() {
        XCTAssertFalse(repository.isFavorite(repositoryData))
        try! repository.add(repositoryData)
        XCTAssertTrue(repository.isFavorite(repositoryData))
    }
}
