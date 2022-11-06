//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryDetailViewController: UIViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var stargazersCountLabel: UILabel!
    @IBOutlet weak var wachersCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var IsssLbl: UILabel!
    
    var repositoryListViewController: RepositoryListViewController!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repo = repositoryListViewController.repositoryDataList[repositoryListViewController.repositoryListIndex]
        
        languageLabel.text = "Written in \(repo["language"] as? String ?? "")"
        stargazersCountLabel.text = "\(repo["stargazers_count"] as? Int ?? 0) stars"
        wachersCountLabel.text = "\(repo["wachers_count"] as? Int ?? 0) watchers"
        forksCountLabel.text = "\(repo["forks_count"] as? Int ?? 0) forks"
        IsssLbl.text = "\(repo["open_issues_count"] as? Int ?? 0) open issues"
        getImage()
    }
    
    func getImage() {
        let repo = repositoryListViewController.repositoryDataList[repositoryListViewController.repositoryListIndex]
        
        titleLabel.text = repo["full_name"] as? String
        
        if let owner = repo["owner"] as? [String: Any] {
            if let imgURL = owner["avatar_url"] as? String {
                URLSession.shared.dataTask(with: URL(string: imgURL)!) { data, _, _ in
                    let img = UIImage(data: data!)!
                    DispatchQueue.main.async {
                        self.avatarImageView.image = img
                    }
                }.resume()
            }
        }
    }
}
