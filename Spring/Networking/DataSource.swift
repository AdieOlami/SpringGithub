//
//  DataSource.swift
//  Spring
//
//  Created by Olar's Mac on 4/1/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation


protocol DataSource {
    func getUsers(text: String, completionHandler: @escaping (Result<Users, Error>) -> ())
    func getRepos(text: String, completionHandler: @escaping (Result<[Repos], Error>) -> ())
    func getFollowers(text: String, completionHandler: @escaping (Result<[Followers], Error>) -> ())
}
