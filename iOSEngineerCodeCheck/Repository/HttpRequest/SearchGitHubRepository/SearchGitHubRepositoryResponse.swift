//
//  SearchGitHubRepositoryResponse.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/13.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

struct RepositorySearchResponse: Responsible {
    private(set) var items = [GitHubRepositoryData]()
}
