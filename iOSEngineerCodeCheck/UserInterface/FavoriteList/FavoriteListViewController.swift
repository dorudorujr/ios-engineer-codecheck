//
//  FavoriteListViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/12/10.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa
import RxSwiftExt

protocol FavoriteListCoordinatorDelegate: AnyObject {
    func showDetail(with repositoryData: GitHubRepositoryData)
}

class FavoriteListViewController: UIViewController {
    typealias State = FavoriteListState
    typealias Store = RxStore<State>
    typealias Coordinator = FavoriteListCoordinatorDelegate
    typealias SectionModel = RxDataSources.SectionModel<SectionID, SectionItem>
    typealias DataSource = RxTableViewSectionedReloadDataSource<SectionModel>
    
    private var store: Store!
    private var coordinator: Coordinator!
    private var favoriteThunkCreator: FavoriteRepositoryDataThunkCreator!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "お気に入り画面"
        navigationItem.largeTitleDisplayMode = .always
        
        tableView.register(.init(nibName: "RepositoryListCell", bundle: nil), forCellReuseIdentifier: "RepositoryListCell")
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.dispatch(favoriteThunkCreator.repositorys())
    }
    
    // MARK: - Rx
    private let disposeBag = DisposeBag()
    
    private func bind() {
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
        
        tableView.rx.itemSelected
            .bind(to: Binder(self) { me, indexPath in
                me.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        store.rx.shouldHideTableView
            .drive(tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        store.rx.shouldHideEmptyView
            .drive(emptyView.rx.isHidden)
            .disposed(by: disposeBag)
        
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

extension FavoriteListViewController: DependencyInjectable {
    typealias Dependency = (store: Store, coordinator: Coordinator, favoriteThunkCreator: FavoriteRepositoryDataThunkCreator)
    
    func inject(with dependency: Dependency) {
        store = dependency.store
        coordinator = dependency.coordinator
        favoriteThunkCreator = dependency.favoriteThunkCreator
    }
}

extension FavoriteListViewController {
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

extension FavoriteListViewController.SectionModel {
    init(items: [GitHubRepositoryData]) {
        let items = items.map(FavoriteListViewController.SectionItem.repository)
        self.init(model: .firstSection, items: items)
    }
}

extension Reactive where Base: FavoriteListViewController.Store {
    private var isEmptyRepositorys: Observable<Bool> {
        base.stateObservable.mapAt(\.repositorys)
            .distinctUntilChanged()
            .map(\.isEmpty)
    }
    
    var shouldHideEmptyView: Driver<Bool> {
        isEmptyRepositorys
            .not()
            .asDriver(onErrorDriveWith: .never())
    }
    
    var shouldHideTableView: Driver<Bool> {
        isEmptyRepositorys
            .asDriver(onErrorDriveWith: .never())
    }
    
    private var firstSection: Observable<FavoriteListViewController.SectionModel> {
        base.stateObservable.mapAt(\.repositorys)
            .distinctUntilChanged()
            .map(FavoriteListViewController.SectionModel.init)
    }
    
    var sections: Driver<[FavoriteListViewController.SectionModel]> {
        Observable
            .combineLatest([
                firstSection
            ])
            .asDriver(onErrorDriveWith: .never())
    }
}
