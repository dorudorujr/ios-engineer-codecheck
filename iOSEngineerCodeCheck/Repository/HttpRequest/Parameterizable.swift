//
//  Parameterizable.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/13.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

protocol Parameterizable {
    /// パラメータを入れ込んだパスを返却する
    ///
    /// - Parameter pathFormat: パスのフォーマット
    /// - Returns: パラメータを代入したパス
    func pathWithParameter(pathFormat: String) -> String
}
