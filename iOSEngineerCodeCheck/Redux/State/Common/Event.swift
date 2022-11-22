//
//  Event.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/22.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

/// `State`で、イベントを表すプロパティを定義する時に使用する
///
/// アラートで表示する情報のような、揮発性の（イベント性質の）プロパティを定義する場合に利用する。
///
/// e.g. API通信のエラーをアラート表示する場合
/// ```swift
/// struct MyState {
///     var error: Event<Error>?
/// }
///
/// let store = RxStore<MyState>(state: nil)
///
/// store.stateObservable.map { $0.error }
///     .distinctUntilChanged() // 処理済みのエラーは流さない
///     .bind(to: Binder(self) { me, error in
///         // エラーアラート表示処理
///     })
///     .disposed(by: disposeBag)
/// ```
struct Event<T>: RawRepresentable {
    var rawValue: T
    private var id = UUID()

    init(rawValue: T) {
        self.rawValue = rawValue
    }
}

extension Event: Equatable {
    static func == (lhs: Event<T>, rhs: Event<T>) -> Bool {
        lhs.id == rhs.id
    }
}

extension Event: Error where T: Error {}
