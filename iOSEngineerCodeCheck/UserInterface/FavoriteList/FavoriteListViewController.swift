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

protocol FavoriteListCoordinatorDelegate: AnyObject {
    func showDetail(with repositoryData: GitHubRepositoryData)
}

class FavoriteListViewController: UITableViewController {
    typealias State = FavoriteListState
    typealias Store = RxStore<State>
    typealias Coordinator = FavoriteListCoordinatorDelegate
    typealias SectionModel = RxDataSources.SectionModel<SectionID, SectionItem>
    typealias DataSource = RxTableViewSectionedReloadDataSource<SectionModel>
    
    private var store: Store!
    private var coordinator: Coordinator!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "お気に入り画面"
        navigationItem.largeTitleDisplayMode = .always
        tableView.dataSource = nil
        tableView.delegate = nil
        
        bind()
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

extension FavoriteListViewController: DependencyInjectable {
    typealias Dependency = (store: Store, coordinator: Coordinator)
    
    func inject(with dependency: Dependency) {
        store = dependency.store
        coordinator = dependency.coordinator
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
