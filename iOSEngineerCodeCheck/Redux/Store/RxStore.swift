//
//  RxStore.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/23.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import ReSwift
import ReSwiftThunk
import RxRelay
import RxSwift

class RxStore<AnyStateType>: StoreSubscriber {
    lazy var stateObservable: Observable<AnyStateType> = stateRelay.asObservable()
        .observe(on: MainScheduler.instance)
        .share(replay: 1, scope: .whileConnected)

    var state: AnyStateType { stateRelay.value }

    private let stateRelay: BehaviorRelay<AnyStateType>
    private let store: Store<AnyStateType>

    private init(store: Store<AnyStateType>) {
        self.store = store
        self.stateRelay = BehaviorRelay(value: store.state)
        self.store.subscribe(self)
    }

    convenience init(reducer: @escaping Reducer<AnyStateType>, state: AnyStateType?, middleware: [Middleware<AnyStateType>] = [], automaticallySkipsRepeats: Bool = true) {
        self.init(store: .init(
            reducer: reducer,
            state: state,
            middleware: middleware,
            automaticallySkipsRepeats: automaticallySkipsRepeats)
        )
    }

    deinit {
        self.store.unsubscribe(self)
    }

    func newState(state: AnyStateType) {
        self.stateRelay.accept(state)
    }
}

extension RxStore where AnyStateType: Reducible {
    convenience init(state: AnyStateType?, middleware: [Middleware<AnyStateType>] = [], automaticallySkipsRepeats: Bool = true) {
        self.init(store: .init(
            reducer: AnyStateType.reducer,
            state: state,
            middleware: middleware,
            automaticallySkipsRepeats: automaticallySkipsRepeats)
        )
    }
}

protocol Dispatchable: AnyObject {
    func dispatch(_ action: Action)
}

extension RxStore: Dispatchable {
    func dispatch(_ action: Action) {
        store.dispatch(action)
    }

    func dispatch(_ thunk: Thunk<AnyStateType>) {
        store.dispatch(thunk)
    }
}

extension Reactive where Base: Dispatchable {
    var dispatch: AnyObserver<ReSwift.Action> {
        .init { [weak base] event in
            if let action = event.element {
                base?.dispatch(action)
            }
        }
    }
}
