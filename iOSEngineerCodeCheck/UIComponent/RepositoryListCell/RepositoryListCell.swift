//
//  RepositoryListCell.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/12/20.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit
import Kingfisher

class RepositoryListCell: UITableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var star: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(avatarImageUrl: String, fullName: String, description: String?, starCount: Int) {
        avatarImage.kf.setImage(with: URL(string: avatarImageUrl))
        self.fullName.text = fullName
        descriptionLabel.text = description
        descriptionLabel.isHidden = description == nil
        star.text = starCount.description
    }
    
}
