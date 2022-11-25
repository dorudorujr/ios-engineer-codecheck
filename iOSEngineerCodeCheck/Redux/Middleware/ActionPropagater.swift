//
//  ActionPropagater.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/25.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import RxSwift
import ReSwift

protocol PropagatableAction: Action {
    /// 発生点ID、not null時は自身のStoreに対して直接dispatchされたActionではなく、ActionPropagator経由でdispatchされたAction
    var originatingId: String? { get set }
}

/// 異なるインスタンスのStoreに対してActionを伝播させるやつ
class ActionPropagator {
    
    /// デフォルトインスタンス
    static let `default` = ActionPropagator()
    
    private let propagatingAction = PublishSubject<Action>()
    /// Actionの伝播ストリーム
    var propagatingActionObservable: Observable<Action> {
        return propagatingAction.asObservable()
    }
    
    /// 伝播実行
    /// - Parameter action: 対象となるAction
    private func propagate(action: PropagatableAction) {
        propagatingAction.onNext(action)
    }
    
    /// 実行済みAction, 自分が伝播の発生点
    struct ProcessedAction: Action {}
    
    /// 伝播可能なActionを受け取ったと時にActionPropagator経由でActionを伝播するMiddlewareを作る
    func propagatorMiddleware<T>(originatingId: String)-> Middleware<T> {
        return { dispatch, getState in
            return { next in
                return { [weak self] action in
                    self?.dispatch(next: next, action: action, state: getState(), originatingId: originatingId)
                }
            }
        }
    }
    
    /// Middleware内部処理
    private func dispatch<T>(next: @escaping ReSwift.DispatchFunction, action: Action, state: T?, originatingId: String) {
        if action.isPropagated {
            if (action as! PropagatableAction).isPropagated(by: originatingId) {
                return next(ActionPropagator.ProcessedAction())
            } else {
                return next(action)
            }
        } else {
            if var action = action as? PropagatableAction {
                action.originatingId = originatingId
                propagate(action: action)
                return next(action)
            } else {
                return next(action)
            }
        }
    }
}

fileprivate extension Action {
    /// 伝播されてきたActionか
    var isPropagated: Bool {
        if let action = self as? PropagatableAction {
            return action.originatingId != nil
        }
        return false
    }
}

fileprivate extension PropagatableAction {
    /// stateによって伝播されたActionか
    func isPropagated(by originatingId: String) -> Bool {
        return self.originatingId == originatingId
    }
}
