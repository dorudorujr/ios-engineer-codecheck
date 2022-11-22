//
//  RequestThunkCreator.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/22.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import ReSwift
import ReSwiftThunk
import RxSwift

class RequestThunkCreator<Request: Requestable> {
    typealias Action = RequestAction<Request>
    
    private(set) var canceller: Task<(), Never>?
    private let request: Request

    init(request: Request) {
        self.request = request
    }
    
    func request<State: RequestActionReducible>(parameter: Request.Parameter, disposeBag: DisposeBag) -> Thunk<State> {
        .init { dispatch, _ in
            dispatch(Action.start(parameter: parameter))
            
            self.canceller = Task {
                do {
                    let response = try await self.request.send(with: parameter)
                    dispatch(Action.success(parameter: parameter, response: response))
                } catch {
                    dispatch(Action.failure(parameter: parameter, error: error))
                }
            }
        }
    }
}
