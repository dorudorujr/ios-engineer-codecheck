//
//  Owner.swift
//  iOSEngineerCodeCheck
//
//  Created by 杉岡成哉 on 2022/11/13.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

struct Owner: Codable {
    var avatarUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
    }
}

extension Owner: Equatable {}
