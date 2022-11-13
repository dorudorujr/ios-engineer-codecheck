//
//  Requestable.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/13.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol Requestable {
    // typealiasにて定義必須
    associatedtype Parameter: Parameterizable
    associatedtype Response: Responsible
    
    func send(with parameter: Parameter) async throws -> Response
}

protocol HTTPRequestable: Requestable {
    // 通信先情報 実装必須
    var hostName: String { get } // https://hogehoge.co.jp/fugafuga/piyo の https://hogehoge.co.jp まで
    var path: String { get } // https://hogehoge.co.jp/fugafuga/piyo の /fugafuga/piyo まで
}

/// GetRequestable
/// Getリクエストを行うProtocol
protocol GetRequestable: HTTPRequestable {}

extension GetRequestable {
    func send(with parameter: Parameter) async throws -> Response {
        let path = parameter.pathWithParameter(pathFormat: self.path)
        guard let url = URL(string: hostName + path) else {
            throw APIClientError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let utf8Data = String(data: data, encoding: String.Encoding.utf8)?.data(using: .utf8) else {
            throw APIClientError.dataMappingError
        }
        return try Response.decoder.decode(Response.self, from: utf8Data)
    }
}
