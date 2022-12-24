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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurEffectView?.frame = self.frame
    }

    private func nibInit() {
        let nib = UINib(nibName: "BlurEffectView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        addSubview(view)
        
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        guard let blurEffectView = blurEffectView else {
            return
        }
        addSubview(blurEffectView)
    }
}
