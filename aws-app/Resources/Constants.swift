//
//  Constants.swift
//  aws-app
//
//  Created by Linh Do on 1/18/19.
//  Copyright © 2019 Linh Do. All rights reserved.
//

import Foundation

struct K {
    struct ProductionServer {
//        static let baseURL = "http://localhost:5000"
        static let baseURL = "http://35.247.159.133"
    }
    
    struct APIParameterKey {
        static let status = "status"
    }
    
    struct APIToken {
        static let token = "Bearer hWd3uNMVpjaRAbPs9Nt3"
    }
    
    struct APIUserId {
        static let id = "ldt"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case userId = "user-id"
}

enum ContentType: String {
    case json = "application/json"
}
