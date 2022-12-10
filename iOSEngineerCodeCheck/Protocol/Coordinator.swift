//
//  Coordinator.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/20.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {}

// Top画面のTabBarControllerの上に乗るViewControllerのCoordinator
protocol TopCoordinator: Coordinator {
    func make()
}

// Top画面以降のViewControllerのCoordinator
protocol SecondaryCoordinator: Coordinator {
    func start(with parent: UIViewController)
}
