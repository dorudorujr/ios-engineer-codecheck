//
//  Coordinator.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/20.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit

public protocol Coordinator: AnyObject {
    func start(with parent: UIViewController)
}
