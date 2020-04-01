//
//  User.swift
//  Spring
//
//  Created by Olar's Mac on 4/1/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation

struct Users: Codable {
    let totalCount: Int
    let items: [Items]
}

struct Items: Codable {
    let id: Int
    let avatarUrl, login: String
}

extension Items {
    func getImagePath() -> URL? {
        return URL(string: avatarUrl)
    }
}

struct Repos: Codable {
    let id: Int
}

struct Followers: Codable {
    let id: Int
}
