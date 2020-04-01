//
//  SpringTests.swift
//  SpringTests
//
//  Created by Olar's Mac on 4/1/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import XCTest
@testable import Spring
import Moya

class SpringTests: XCTestCase {
    var provider: MoyaProvider<Api>!
    override func setUp() {
        
        provider = MoyaProvider<Api>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func customEndpointClosure(_ target: Api) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }

    func usersUrl() {

        provider.request(.getUsers(text: "AdieOlami"), objectModel: Users.self, success: { (response) in
            XCTAssert(response.totalCount == 1, "Users Count")
            
            XCTAssertEqual(response.items.first?.getImagePath(), URL(string: "https://avatars0.githubusercontent.com/u/22158320?v=4")!, "Image URL")
            
            guard let user = response.items.first else {
                XCTFail("photo is nil.")
                return
            }
            
            XCTAssertEqual(user.login, "AdieOlami")
            XCTAssertEqual(user.id, 22158320)
            
        }) { (error) in
            XCTAssert(false, "not in here")
        }
    }
    
    func getFollowersUrl() {

        provider.request(.getFollowers(name: "AdieOlami"), arrayModel: Followers.self, success: { (response) in
            XCTAssert(response.count > 3, "Followers Count")
            
        }) { (error) in
            XCTAssert(false, "not in here")
        }
    }

    func getRepoUrl() {

        provider.request(.getRepo(name: "AdieOlami"), arrayModel: Repos.self, success: { (response) in
            XCTAssert(response.count > 10, "Repo Count")
            
        }) { (error) in
            XCTAssert(false, "not in here")
        }
    }
}
