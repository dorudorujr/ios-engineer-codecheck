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
    private(set) var isFavorite = false
}

extension RepositoryDetailState {
    enum Action: ReSwift.Action {
        case changeFavorite(isFavorite: Bool)
    }
}

extension RepositoryDetailState: Reducible {
    static var reducer: Reducer<RepositoryDetailState> {
        { action, state in
            var state = state ?? .init()
            
            switch action {
            case let action as RepositoryDetailState.Action:
                state.reduce(action: action)
            default:
                break
            }
            
            return state
        }
    }
    
    private mutating func reduce(action: RepositoryDetailState.Action) {
        switch action {
        case let .changeFavorite(isFavorite):
            self.isFavorite = isFavorite
        }
    }
}
