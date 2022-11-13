//
//  SearchGitHubRepositoryParameter.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/13.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

struct SearchGitHubRepositoryParameter: Parameterizable {
    let searchWord: String
    
    func pathWithParameter(pathFormat: String) -> String {
        "\(pathFormat)?q=\(searchWord)"
    }
}
