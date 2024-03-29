//
//  FavoriteRepositoryDataThunkCreator.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/12/13.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import ReSwiftThunk
import ReSwift

class FavoriteRepositoryDataThunkCreator {
    typealias Action = FavoriteRepositoryDataAction
    
    private let repository: FavoriteRepositoryDataRepository
    
    init(repository: FavoriteRepositoryDataRepository) {
        self.repository = repository
    }
    
    func repositorys<State: Reducible>() -> Thunk<State> {
        .init { dispatch, _ in
            dispatch(Action.getSuccess(repositorys: self.repository.repositorys()))
        }
    }
    
    func changeFavoriteStatus<State: Reducible>(of repository: GitHubRepositoryData) -> Thunk<State> {
        .init { dispatch, _ in
            do {
                let isFavorite = self.repository.isFavorite(repository)
                if isFavorite {
                    try self.repository.delete(repository)
                    dispatch(Action.deletionSuccess)
                } else {
                    try self.repository.add(repository)
                    dispatch(Action.additionalSuccess)
                }
            } catch {
                dispatch(Action.realmFailure(error: error))
            }
        }
    }
    
    func isFavorite<State>(_ repository: GitHubRepositoryData) -> Thunk<State> {
        .init { dispatch, _ in
            dispatch(Action.changeFavorite(isFavorite: self.repository.isFavorite(repository)))
        }
    }
}
