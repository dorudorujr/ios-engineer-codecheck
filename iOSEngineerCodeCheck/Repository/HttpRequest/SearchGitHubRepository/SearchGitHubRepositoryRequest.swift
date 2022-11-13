//
//  SearchGitHubRepositoryRequest.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/13.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

protocol SearchGitHubRepositoryRequestable: GetRequestable where Parameter == SearchGitHubRepositoryParameter {}

extension SearchGitHubRepositoryRequestable {
    var hostName: String { return "https://api.github.com" }
    var path: String { return "/search/repositories" }
}

struct SearchGitHubRepositoryRequest: SearchGitHubRepositoryRequestable {}
