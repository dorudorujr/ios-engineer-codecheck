//
//  RequestAction.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/22.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import ReSwift

/// API通信用のAction
enum RequestAction<Request: Requestable>: Action {
    case start(parameter: Request.Parameter)
    case success(parameter: Request.Parameter, response: Request.Response)
    case failure(parameter: Request.Parameter, error: Error)
}
