//
//  LoadingView.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/12/04.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    // Window
    private var loadingWindow: UIWindow?
    
    // UIActivityIndicatorView
    private let loadingIndicatorView = UIActivityIndicatorView()
    
    // MARK: - Singleton
    static var sharedInstance = LoadingView()
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)

        loadingIndicatorView.frame.size = CGSize(width: 50, height: 50)
        loadingIndicatorView.center = self.center
        loadingIndicatorView.backgroundColor = UIColor.clear
        loadingIndicatorView.hidesWhenStopped = true

        addSubview(loadingIndicatorView)
    }
    
    /**
     Start loading
    */
    class func show() {
        DispatchQueue.main.async(execute: {
            let loadingView = LoadingView.sharedInstance
            loadingView.frame = UIScreen.main.bounds
            loadingView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            
            loadingView.loadingIndicatorView.startAnimating()
            
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            loadingView.loadingWindow = UIWindow(windowScene: scene)
            loadingView.loadingWindow?.frame = UIScreen.main.bounds
            loadingView.loadingWindow?.backgroundColor = UIColor.clear
            loadingView.loadingWindow?.windowLevel = UIWindow.Level.alert - 1

            loadingView.loadingWindow?.makeKeyAndVisible()
            loadingView.loadingWindow?.addSubview(loadingView)
        })
    }
    
    /**
     Stop loading
    */
    class func dismiss() {
        let loadingView = LoadingView.sharedInstance
        loadingView.loadingIndicatorView.stopAnimating()
        loadingView.removeFromSuperview()
        // Back to main window
        loadingView.loadingWindow?.windowLevel = UIWindow.Level(rawValue: -1_000.0)
        loadingView.loadingWindow = nil
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
    }
}
