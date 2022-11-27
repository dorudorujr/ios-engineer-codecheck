//
//  RepositoryListState.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/23.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import ReSwift
import RxSwift

struct RepositoryListState {
    private(set) var loadingState = LoadingState()
    private(set) var error: Event<Error>?
    private var responses = [SearchGitHubRepositoryRequest.Response]()
    
    var repositorys: [GitHubRepositoryData] {
        responses.flatMap { $0.items }
    }
}

extension RepositoryListState: Reducible {
    static var reducer: Reducer<RepositoryListState> {
        { action, state in
            var state = state ?? .init()
            
            switch action {
            case let action as RepositoryListThunkCreator.Action:
                state.reduce(requestAction: action)
            default:
                break
            }
            
            return state
        }
    }
}

extension RepositoryListState: RequestActionReducible {
    mutating func reduce(requestAction: RepositoryListThunkCreator.Action) {
        switch requestAction {
        case .start:
            loadingState.increment()
        case let .success(_, r):
            loadingState.decrement()
            responses = [r]
            error = nil
        case let .failure(_, e):
            loadingState.decrement()
            error = .init(rawValue: e)
        }
    }
}
