//
//  FavoriteRepositoryDataAction.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/12/13.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import ReSwift

/// リポジトリお気に入り用Action
enum FavoriteRepositoryDataAction: Action {
    case getSuccess(repositorys: [GitHubRepositoryData])
    case additionalSuccess
    case deletionSuccess
    case changeFavorite(isFavorite: Bool)
    case realmFailure(error: Error)
}
