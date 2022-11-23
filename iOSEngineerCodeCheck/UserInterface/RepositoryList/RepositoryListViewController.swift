//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

protocol RepositoryListCoordinatorDelegate: AnyObject {
    func showDetail(with repositoryData: GitHubRepositoryData)
}

class RepositoryListViewController: UITableViewController, UISearchBarDelegate {
    typealias State = RepositoryListState
    typealias Store = RxStore<State>
    typealias Repository = SearchGitHubRepositoryRequest
    typealias Coordinator = RepositoryListCoordinatorDelegate
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var store: Store!
    private var repository: Repository!
    private var coordinator: Coordinator!
    private var requestThunkCreator: RepositoryListThunkCreator!
    
    private var repositoryDataList = [GitHubRepositoryData]()
    private var searchWord: String?
    private var canceller: Task<(), Never>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Root View Controller"
        navigationItem.largeTitleDisplayMode = .always
        searchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
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
                self.repositoryDataList = try await repository.send(with: parameter).items
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("API Error:\(error)")
                fatalError()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryDataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "subtitleCell")
        let rp = repositoryDataList[indexPath.row]
        cell.textLabel?.text = rp.fullName
        cell.detailTextLabel?.text = rp.language
        cell.tag = indexPath.row
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator.showDetail(with: repositoryDataList[indexPath.row])
    }
}

extension RepositoryListViewController: DependencyInjectable {
    typealias Dependency = (store: Store, repository: Repository, coordinator: Coordinator, requestThunkCreator: RepositoryListThunkCreator)
    
    func inject(with dependency: Dependency) {
        store = dependency.store
        repository = dependency.repository
        coordinator = dependency.coordinator
        requestThunkCreator = dependency.requestThunkCreator
    }
}
