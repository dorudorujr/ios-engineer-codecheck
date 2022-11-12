//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

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
        
        var repo: [String: Any] = [:]
        if let repositoryListIndex = repositoryListViewController?.repositoryListIndex,
           let repository = repositoryListViewController?.repositoryDataList[repositoryListIndex] {
            repo = repository
        }
        
        languageLabel.text = "Written in \(repo["language"] as? String ?? "")"
        stargazersCountLabel.text = "\(repo["stargazers_count"] as? Int ?? 0) stars"
        wachersCountLabel.text = "\(repo["watchers_count"] as? Int ?? 0) watchers"
        forksCountLabel.text = "\(repo["forks_count"] as? Int ?? 0) forks"
        openIssuesCountLabel.text = "\(repo["open_issues_count"] as? Int ?? 0) open issues"
        setUpAvatarImageView()
    }
    
    private func setUpAvatarImageView() {
        guard let repositoryListIndex = repositoryListViewController?.repositoryListIndex,
              let repo = repositoryListViewController?.repositoryDataList[repositoryListIndex] else {
            return
        }
        
        // TODO: 正しい場所に移動する
        titleLabel.text = repo["full_name"] as? String
        
        guard let owner = repo["owner"] as? [String: Any],
              let avatarURL = owner["avatar_url"] as? String,
              let imgURL = URL(string: avatarURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: imgURL) { [weak self] data, _, _ in
            guard let self = self else { return }
            guard let data = data,
                  let img = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self.avatarImageView.image = img
            }
        }.resume()
    }
}
