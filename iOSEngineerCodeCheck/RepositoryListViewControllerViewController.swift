//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryListViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var repositoryDataList: [[String: Any]] = []
    
    var repositoryListIndex: Int?
    
    private var searchWord: String?
    private var canceller: Task<(), Never>?
    private let searchRepository = SearchGitHubRepositoryRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // 初期のテキストを消すためにこのタイミングで空文字を設定
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        canceller?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchWord = searchBar.text
        
        guard let searchWord = searchWord, !searchWord.isEmpty else {
            return
        }
        
        fetch(parameter: .init(searchWord: searchWord))
    }
    
    private func fetch(parameter: SearchGitHubRepositoryParameter) {
        canceller = Task {
            do {
                let obj = try await searchRepository.send(with: parameter)
                guard let items = obj["items"] as? [[String: Any]] else {
                    return
                }
                self.repositoryDataList = items
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("API Error:\(error)")
                fatalError()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            guard let detailViewController = segue.destination as? RepositoryDetailViewController else {
                return
            }
            detailViewController.repositoryListViewController = self
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryDataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "subtitleCell")
        let rp = repositoryDataList[indexPath.row]
        cell.textLabel?.text = rp["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = rp["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        repositoryListIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}
