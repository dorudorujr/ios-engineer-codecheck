//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt
import Kingfisher

class RepositoryDetailViewController: UIViewController {
    typealias State = RepositoryDetailState
    typealias Store = RxStore<State>
    
    @IBOutlet weak private var blurEffectBackground: BlurEffectView!
    @IBOutlet weak private var avatarImageView: UIImageView!
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    
    @IBOutlet weak private var languageLabel: UILabel!
    
    @IBOutlet weak private var stargazersCountLabel: UILabel!
    @IBOutlet weak private var wachersCountLabel: UILabel!
    @IBOutlet weak private var forksCountLabel: UILabel!
    @IBOutlet weak private var openIssuesCountLabel: UILabel!
    @IBOutlet weak private var cardViewTopConstraint: NSLayoutConstraint!
    
    private var store: Store!
    private var favoriteThunkCreator: FavoriteRepositoryDataThunkCreator!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        let favoriteButton = UIBarButtonItem(image: .init(systemName: "heart"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = favoriteButton
        
        cardViewTopConstraint.constant += SceneDelegate.statusBarHeight
        
        bind()
        guard let repositoryData = store.state.repositoryData else {
            return
        }
        store.dispatch(favoriteThunkCreator.isFavorite(repositoryData))
    }
    
    // MARK: - Rx
    private let disposeBag = DisposeBag()
    
    private func bind() {
        store.rx.fullName
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        store.rx.descriptionText
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        store.rx.language
            .drive(languageLabel.rx.text)
            .disposed(by: disposeBag)
        
        store.rx.stargazersCount
            .drive(stargazersCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        store.rx.watchersCount
            .drive(wachersCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        store.rx.forksCount
            .drive(forksCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        store.rx.openIssuesCount
            .drive(openIssuesCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        store.rx.avatarImage
            .drive(Binder(self) { me, value in
                me.avatarImageView.kf.setImage(with: value)
                me.blurEffectBackground.image.kf.setImage(with: value)
            })
            .disposed(by: disposeBag)
        
        store.rx.isFavorite
            .drive(Binder(self) { me, isFavorite in
                me.navigationItem.rightBarButtonItem?.image = isFavorite ? .init(systemName: "heart.fill") : .init(systemName: "heart")
            })
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .bind(to: Binder(self) { me, _ in
                guard let repositoryData = me.store.state.repositoryData else {
                    return
                }
                me.store.dispatch(me.favoriteThunkCreator.changeFavoriteStatus(of: repositoryData))
            })
            .disposed(by: disposeBag)
            
    }
}

extension RepositoryDetailViewController: DependencyInjectable {
    typealias Dependency = (store: Store, favoriteThunkCreator: FavoriteRepositoryDataThunkCreator)
    
    func inject(with dependency: Dependency) {
        store = dependency.store
        favoriteThunkCreator = dependency.favoriteThunkCreator
    }
}

extension Reactive where Base: RepositoryDetailViewController.Store {
    var isFavorite: Driver<Bool> {
        base.stateObservable.mapAt(\.isFavorite)
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .never())
    }
    
    var fullName: Driver<String> {
        base.stateObservable.mapAt(\.repositoryData)
            .unwrap()
            .distinctUntilChanged()
            .mapAt(\.fullName)
            .asDriver(onErrorDriveWith: .never())
    }
    
    var descriptionText: Driver<String?> {
        base.stateObservable.mapAt(\.repositoryData)
            .unwrap()
            .distinctUntilChanged()
            .mapAt(\.description)
            .asDriver(onErrorDriveWith: .never())
    }
    
    var language: Driver<String> {
        base.stateObservable.mapAt(\.repositoryData)
            .unwrap()
            .distinctUntilChanged()
            .mapAt(\.language)
            .map { value in
                "Written in \(value)"
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    var stargazersCount: Driver<String> {
        base.stateObservable.mapAt(\.repositoryData)
            .unwrap()
            .distinctUntilChanged()
            .mapAt(\.stargazersCount)
            .map { value in
                "\(value) stars"
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    var watchersCount: Driver<String> {
        base.stateObservable.mapAt(\.repositoryData)
            .unwrap()
            .distinctUntilChanged()
            .mapAt(\.watchersCount)
            .map { value in
                "\(value) watchers"
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    var forksCount: Driver<String> {
        base.stateObservable.mapAt(\.repositoryData)
            .unwrap()
            .distinctUntilChanged()
            .mapAt(\.forksCount)
            .map { value in
                "\(value) forks"
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    var openIssuesCount: Driver<String> {
        base.stateObservable.mapAt(\.repositoryData)
            .unwrap()
            .distinctUntilChanged()
            .mapAt(\.openIssuesCount)
            .map { value in
                "\(value) open issues"
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    var avatarImage: Driver<URL> {
        base.stateObservable.mapAt(\.repositoryData)
            .unwrap()
            .distinctUntilChanged()
            .mapAt(\.owner.avatarUrl)
            .map { value in
                URL(string: value)
            }
            .unwrap()
            .asDriver(onErrorDriveWith: .never())
    }
}
