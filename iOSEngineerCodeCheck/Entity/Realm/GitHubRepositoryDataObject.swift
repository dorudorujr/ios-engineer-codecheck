//
//  GitHubRepositoryDataObject.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/12/13.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import RealmSwift

class GitHubRepositoryDataObject: Object {
    @objc dynamic var id = 0
    @objc dynamic var fullName = ""
    @objc dynamic var owner = OwnerObject()
    @objc dynamic var stargazersCount = 0
    @objc dynamic var watchersCount = 0
    @objc dynamic var language = ""
    @objc dynamic var forksCount = 0
    @objc dynamic var openIssuesCount = 0
    
    override static func primaryKey() -> String? {
        "id"
    }
}
