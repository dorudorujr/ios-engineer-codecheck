//
//  GitHubRepositoryData.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/13.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

struct GitHubRepositoryData: Codable {
    var id: Int
    var fullName: String
    var owner: Owner
    var stargazersCount: Int
    var watchersCount: Int
    var language: String
    var forksCount: Int
    var openIssuesCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case owner
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case language
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
    }
}
