//
//  Responsible.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/13.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol Responsible: Decodable {
    static var decoder: JSONDecoder { get }
}

extension Responsible {
    static var decoder: JSONDecoder {
        return JSONDecoder()
    }
}
