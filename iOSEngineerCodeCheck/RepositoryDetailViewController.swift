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
    
    var repositoryListViewController: RepositoryListViewController?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var repo: GitHubRepositoryData?
        if let repositoryListIndex = repositoryListViewController?.repositoryListIndex,
           let repository = repositoryListViewController?.repositoryDataList[repositoryListIndex] {
            repo = repository
        }
        
        languageLabel.text = "Written in \(repo?.language ?? "")"
        stargazersCountLabel.text = "\(repo?.stargazersCount ?? 0) stars"
        wachersCountLabel.text = "\(repo?.watchersCount ?? 0) watchers"
        forksCountLabel.text = "\(repo?.forksCount ?? 0) forks"
        openIssuesCountLabel.text = "\(repo?.openIssuesCount ?? 0) open issues"
        
        setUpAvatarImageView()
    }
    
    private func setUpAvatarImageView() {
        guard let repositoryListIndex = repositoryListViewController?.repositoryListIndex,
              let repo = repositoryListViewController?.repositoryDataList[repositoryListIndex] else {
            return
        }
        
        // TODO: 正しい場所に移動する
        titleLabel.text = repo.fullName
        
        guard let imgURL = URL(string: repo.owner.avatarUrl) else {
            return
        }
        
        DispatchQueue.main.async {
            self.avatarImageView.kf.setImage(with: imgURL)
        }
    }
}
