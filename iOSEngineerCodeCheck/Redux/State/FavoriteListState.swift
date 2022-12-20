//
//  FavoriteListState.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/12/10.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import ReSwift

struct FavoriteListState {
    private(set) var repositorys = [GitHubRepositoryData]()
}

extension FavoriteListState {
    enum Action: ReSwift.Action {
        case setRepositorys(repositorys: [GitHubRepositoryData])
    }
}

extension FavoriteListState: Reducible {
    static var reducer: Reducer<FavoriteListState> {
        { action, state in
            var state = state ?? .init()
            
            switch action {
            case let action as FavoriteListState.Action:
                state.reduce(action: action)
            case let action as FavoriteRepositoryDataThunkCreator.Action:
                state.reduce(favoriteAction: action)
            default:
                break
            }
            
            return state
        }
    }
    
    private mutating func reduce(action: FavoriteListState.Action) {
        switch action {
        case let .setRepositorys(repositorys):
            self.repositorys = repositorys
        }
    }
    
    private mutating func reduce(favoriteAction: FavoriteRepositoryDataThunkCreator.Action) {
        switch favoriteAction {
        case let .getSuccess(repositorys):
            self.repositorys = repositorys
        default:
            break
            
        }
    }
}
