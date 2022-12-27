//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt
import RxDataSources
import RxGesture

protocol RepositoryListCoordinatorDelegate: AnyObject {
    func showDetail(with repositoryData: GitHubRepositoryData)
}

class RepositoryListViewController: UITableViewController, UISearchBarDelegate {
    typealias State = RepositoryListState
    typealias Store = RxStore<State>
    typealias Coordinator = RepositoryListCoordinatorDelegate
    typealias SectionModel = RxDataSources.SectionModel<SectionID, SectionItem>
    typealias DataSource = RxTableViewSectionedReloadDataSource<SectionModel>
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var store: Store!
    private var coordinator: Coordinator!
    private var requestThunkCreator: RepositoryListThunkCreator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "検索画面"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        searchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.keyboardDismissMode = .onDrag
        tableView.register(.init(nibName: "RepositoryListCell", bundle: nil), forCellReuseIdentifier: "RepositoryListCell")
        
        bind()
    }
    
    // MARK: - Rx
    private let disposeBag = DisposeBag()
    
    private func bind() {
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text)
            .unwrap()
            .bind(to: Binder(self) { me, value in
                me.searchBar.resignFirstResponder()
                me.store.dispatch(me.requestThunkCreator.request(parameter: .init(searchWord: value), disposeBag: me.disposeBag))
            })
            .disposed(by: disposeBag)
        
        store.rx.sections
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(SectionItem.self)
            .bind(to: Binder(self) { me, item in
                switch item {
                case let .repository(s):
                    me.coordinator.showDetail(with: s)
                }
            })
            .disposed(by: disposeBag)
        
        store.rx.isLoading
            .drive(Binder(self) { _, isLoading in
                isLoading ? LoadingView.show() : LoadingView.dismiss()
            })
            .disposed(by: disposeBag)
        
        view.rx.tapGesture(configuration: { rec, _ in
                rec.cancelsTouchesInView = false
            })
            .when(.recognized)
            .bind(to: Binder(self) { me, _ in
                me.tableView.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        requestThunkCreator.canceller?.cancel()
    }
    
    private lazy var dataSource = DataSource(
        configureCell: { _, tableView, indexPath, item in
            switch item {
            case let .repository(s):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryListCell", for: indexPath ) as? RepositoryListCell else {
                    return .init()
                }
                cell.bind(avatarImageUrl: s.owner.avatarUrl, fullName: s.fullName, description: s.description, starCount: s.stargazersCount)
                cell.tag = indexPath.row
                return cell
            }
        }
    )
}

extension RepositoryListViewController: DependencyInjectable {
    typealias Dependency = (store: Store, coordinator: Coordinator, requestThunkCreator: RepositoryListThunkCreator)
    
    func inject(with dependency: Dependency) {
        store = dependency.store
        coordinator = dependency.coordinator
        requestThunkCreator = dependency.requestThunkCreator
    }
}

extension RepositoryListViewController {
    enum SectionID: String, IdentifiableType {
        case firstSection

        var identity: String {
            self.rawValue
        }
    }
    
    enum SectionItem: IdentifiableType, Equatable {
        case repository(GitHubRepositoryData)

        var identity: Int {
            switch self {
            case let .repository(s): return (s.id)
            }
        }
    }
}

extension RepositoryListViewController.SectionModel {
    init(items: [GitHubRepositoryData]) {
        let items = items.map(RepositoryListViewController.SectionItem.repository)
        self.init(model: .firstSection, items: items)
    }
}

extension Reactive where Base: RepositoryListViewController.Store {
    var isLoading: Driver<Bool> {
        base.stateObservable.mapAt(\.isLoading)
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .never())
    }
    
    var error: Signal<Error> {
        base.stateObservable.mapAt(\.error)
            .unwrap()
            .distinctUntilChanged()
            .mapAt(\.rawValue)
            .asSignal(onErrorSignalWith: .never())
    }
    
    private var firstSection: Observable<RepositoryListViewController.SectionModel> {
        base.stateObservable.mapAt(\.repositorys)
            .distinctUntilChanged()
            .map(RepositoryListViewController.SectionModel.init)
    }
    
    var sections: Driver<[RepositoryListViewController.SectionModel]> {
        Observable
            .combineLatest([
                firstSection
            ])
            .asDriver(onErrorDriveWith: .never())
    }
}
