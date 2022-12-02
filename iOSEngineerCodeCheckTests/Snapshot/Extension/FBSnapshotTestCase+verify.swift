//
//  FBSnapshotTestCase.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 杉岡成哉 on 2022/12/02.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import iOSSnapshotTestCase
import UIKit

extension FBSnapshotTestCase {
    func verify(vc: UIViewController) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        let nc = UINavigationController(rootViewController: vc)
        window.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        window.rootViewController = nc

        nc.beginAppearanceTransition(true, animated: false)
        nc.endAppearanceTransition()
        
        FBSnapshotVerifyLayer(window.layer)
    }
}
