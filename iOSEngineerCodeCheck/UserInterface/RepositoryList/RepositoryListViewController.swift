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
        title = "Root View Controller"
        navigationItem.largeTitleDisplayMode = .always
        searchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
        tableView.dataSource = nil
        tableView.delegate = nil
        
        bind()
    }
    
    // MARK: - Rx
    private let disposeBag = DisposeBag()
    
    private func bind() {
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text)
            .unwrap()
            .bind(to: Binder(self) { me, value in
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
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        requestThunkCreator.canceller?.cancel()
    }
    
    private lazy var dataSource = DataSource(
        configureCell: { _, _, indexPath, item in
            switch item {
            case let .repository(s):
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "subtitleCell")
                cell.textLabel?.text = s.fullName
                cell.detailTextLabel?.text = s.language
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
