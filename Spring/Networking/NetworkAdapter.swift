//
//  NetworkAdapter.swift
//  Spring
//
//  Created by Olar's Mac on 4/1/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation
import Moya

class NetworkAdapter: DataSource {

    private var provider = MoyaProvider<Api>(manager: ApiClient.session, plugins: [NetworkLoggerPlugin(verbose: true)], trackInflights: true)
    
    public static let instance = NetworkAdapter()
    
    func getUsers(text: String, completionHandler: @escaping (Result<Users, Error>) -> ()) {
        provider.request(.getUsers(text: text), objectModel: Users.self, success: { (resp) in
            completionHandler(.success(resp))
        }) { (err) in
            completionHandler(.failure(err))
            print(err)
        }
    }
    
    func getRepos(text: String, completionHandler: @escaping (Result<[Repos], Error>) -> ()) {
        
        provider.request(.getRepo(name: text), objectModel: [Repos].self, success: { (resp) in
            completionHandler(.success(resp))
        }) { (err) in
            completionHandler(.failure(err))
            print(err)
        }
    }
    
    func getFollowers(text: String, completionHandler: @escaping (Result<[Followers], Error>) -> ()) {
        provider.request(.getFollowers(name: text), arrayModel: Followers.self, success: { (resp) in
            completionHandler(.success(resp))
        }) { (err) in
            completionHandler(.failure(err))
            print(err)
        }
    }
    
}
