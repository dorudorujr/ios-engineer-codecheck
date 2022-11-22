//
//  Reducible.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/22.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import ReSwift

protocol Reducible {
    static var reducer: Reducer<Self> { get }
}

protocol RequestActionReducible {
    var loadingState: LoadingState { get }
    var error: Event<Error>? { get }
}

extension RequestActionReducible {
    var isLoading: Bool {
        loadingState.isLoading
    }
}
