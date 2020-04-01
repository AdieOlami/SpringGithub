//
//  ApiClient.swift
//  Spring
//
//  Created by Olar's Mac on 4/1/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation
import Alamofire

class ApiClient {
    static let session: SessionManager = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        return Alamofire.SessionManager(configuration: config)
    }()
}
