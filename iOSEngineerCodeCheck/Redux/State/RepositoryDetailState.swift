//
//  RepositoryDetailState.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/25.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import ReSwift
import RxSwift

struct RepositoryDetailState {
    private(set) var repositoryData: GitHubRepositoryData?
}

extension RepositoryDetailState: Reducible {
    static var reducer: Reducer<RepositoryDetailState> {
        { _, state in
            guard let state = state else {
                return .init()
            }
            return state
        }
    }
}
