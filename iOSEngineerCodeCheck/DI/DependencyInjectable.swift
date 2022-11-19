//
//  DependencyInjectable.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/19.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit

protocol DependencyInjectable {
    associatedtype Dependency
    func inject(with dependency: Dependency)
}

extension InitialSceneType where T: DependencyInjectable {
    func instantiate(with dependency: T.Dependency) -> T {
        let controller = instantiate()
        controller.inject(with: dependency)
        return controller
    }
}
