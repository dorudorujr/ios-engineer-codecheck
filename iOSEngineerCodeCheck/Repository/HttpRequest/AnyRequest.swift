//
//  AnyRequest.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/23.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

struct AnyRequest<Parameter: Parameterizable, Response: Responsible>: Requestable {
    init<Base: Requestable>(_ base: Base) where Base.Parameter == Parameter, Base.Response == Response {
        _send = base.send
    }
    
    func send(with parameter: Parameter) async throws -> Response {
        try await _send(parameter)
    }
    
    private var _send: (Parameter) async throws -> Response
}
