//
//  RequestMock.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 杉岡成哉 on 2022/12/02.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit
@testable import iOSEngineerCodeCheck

class RequestMock<Parameter: Parameterizable, Response: Responsible>: Requestable {
    private(set) var sendCallCount = 0
    var sendHandler: ((Parameter) async throws -> (Response))?
    
    func send(with parameter: Parameter) async throws -> Response {
        sendCallCount += 1
        if let sendHandler = sendHandler {
            let response = try await sendHandler(parameter)
            return response
        }
        fatalError("sendHandler returns can't have a default value thus its handler must be set")
    }
}
