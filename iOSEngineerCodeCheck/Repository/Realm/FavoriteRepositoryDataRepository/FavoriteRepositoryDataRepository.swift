//
//  FavoriteRepositoryDataRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/12/13.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import RealmSwift
import Foundation

protocol FavoriteRepositoryDataRepository {
    func repositorys() -> [GitHubRepositoryData]
    func add(_ repository: GitHubRepositoryData) throws
    func delete(_ repository: GitHubRepositoryData) throws
    func isFavorite(_ repository: GitHubRepositoryData) -> Bool
}

struct FavoriteRepositoryDataRepositoryImpl: FavoriteRepositoryDataRepository {
    private let realm = try! Realm()
    
    func repositorys() -> [GitHubRepositoryData] {
        let results = realm.objects(GitHubRepositoryDataObject.self)
        return results.map {
            .init(id: $0.id,
                  fullName: $0.fullName,
                  owner: .init(avatarUrl: $0.owner?.avatarUrl ?? ""),
                  stargazersCount: $0.stargazersCount,
                  watchersCount: $0.watchersCount,
                  language: $0.language,
                  forksCount: $0.forksCount,
                  openIssuesCount: $0.openIssuesCount)
        }
    }
    
    func add(_ repository: GitHubRepositoryData) throws {
        let object = GitHubRepositoryDataObject(value: [
            "id": repository.id,
            "fullName": repository.fullName,
            "owner": ["avatarUrl": repository.owner.avatarUrl],
            "stargazersCount": repository.stargazersCount,
            "watchersCount": repository.watchersCount,
            "language": repository.language,
            "forksCount": repository.forksCount,
            "openIssuesCount": repository.openIssuesCount
        ])
        try realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    func delete(_ repository: GitHubRepositoryData) throws {
        guard let resultObject = realm.objects(GitHubRepositoryDataObject.self).filter("id == %@", repository.id).first else {
            throw NSError()
        }
        try realm.write {
            realm.delete(resultObject)
        }
    }
    
    func isFavorite(_ repository: GitHubRepositoryData) -> Bool {
        let resultObject = realm.objects(GitHubRepositoryDataObject.self).filter("id == %@", repository.id).first
        return resultObject != nil
    }
}
