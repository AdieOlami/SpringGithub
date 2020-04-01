//
//  Api.swift
//  Spring
//
//  Created by Olar's Mac on 4/1/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import UIKit
import Moya

enum Api {
    case getUsers(text: String)
    case getFollowers(name: String)
    case getRepo(name: String)
}

extension Api: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com/")!
    }
    
    var path: String {
        switch self {
        case .getUsers: return "search/users"
        case .getFollowers(let name): return "users/\(name)/followers"
        case .getRepo(let name): return "users/\(name)/repos"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUsers, .getFollowers, .getRepo: return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getUsers: return DumpResponse.stubbedResponse("Users")
        case .getFollowers: return DumpResponse.stubbedResponse("Follower")
        case .getRepo: return DumpResponse.stubbedResponse("Repo")

        }
    }
    
    var task: Task {
//        let params = Params.build()
        switch self {
        case .getUsers(let text): return .requestParameters(parameters: ["q": text], encoding: URLEncoding.default)
        case .getFollowers, .getRepo: return .requestPlain
        }
    }
    
    public var headers: [String: String]? {
        return [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }
}
