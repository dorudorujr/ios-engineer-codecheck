//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import Kingfisher

class RepositoryDetailViewController: UIViewController {
    @IBOutlet weak private var avatarImageView: UIImageView!
    
    @IBOutlet weak private var titleLabel: UILabel!
    
    @IBOutlet weak private var languageLabel: UILabel!
    
    @IBOutlet weak private var stargazersCountLabel: UILabel!
    @IBOutlet weak private var wachersCountLabel: UILabel!
    @IBOutlet weak private var forksCountLabel: UILabel!
    @IBOutlet weak private var openIssuesCountLabel: UILabel!
    
    var repositoryData: GitHubRepositoryData!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = repositoryData.fullName
        languageLabel.text = "Written in \(repositoryData.language)"
        stargazersCountLabel.text = "\(repositoryData.stargazersCount) stars"
        wachersCountLabel.text = "\(repositoryData.watchersCount) watchers"
        forksCountLabel.text = "\(repositoryData.forksCount) forks"
        openIssuesCountLabel.text = "\(repositoryData.openIssuesCount) open issues"
        
        setUpAvatarImageView()
    }
    
    private func setUpAvatarImageView() {
        guard let imgURL = URL(string: repositoryData.owner.avatarUrl) else {
            return
        }
        
        DispatchQueue.main.async {
            self.avatarImageView.kf.setImage(with: imgURL)
        }
    }
}

extension RepositoryDetailViewController: DependencyInjectable {
    typealias Dependency = GitHubRepositoryData
    
    func inject(with dependency: GitHubRepositoryData) {
        repositoryData = dependency
    }
}
