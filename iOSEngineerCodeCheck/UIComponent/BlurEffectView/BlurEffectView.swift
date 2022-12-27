//
//  BlurEffectView.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/12/24.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit

class BlurEffectView: UIView {
    
    @IBOutlet weak var image: UIImageView!
    
    private var blurEffectView: UIVisualEffectView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibInit()
    }

    private func nibInit() {
        let nib = UINib(nibName: "BlurEffectView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.translatesAutoresizingMaskIntoConstraints = false
        guard let blurEffectView = blurEffectView else {
            return
        }
        addSubview(blurEffectView)
        blurEffectView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        blurEffectView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        blurEffectView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
    }
}
