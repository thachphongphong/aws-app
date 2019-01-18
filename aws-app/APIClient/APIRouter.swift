//
//  APIRouter.swift
//  aws-app
//
//  Created by Linh Do on 1/18/19.
//  Copyright © 2019 Linh Do. All rights reserved.
//

import Alamofire

enum APIRouter: URLRequestConvertible {
    
    case switchDevice(devId:String)
    case statusAll
    case status(devId: String)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .switchDevice:
            return .post
        case .statusAll, .status:
            return .get
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .switchDevice(let devId):
            return "/api/v1.0/\(devId)"
        case .statusAll:
            return "/api/v1.0/status"
        case .status(let devId):
            return "/api/v1.0/\(devId)"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .switchDevice(let devId):
            return [K.APIParameterKey.devId: devId]
        case .statusAll:
            return nil
        case .status(let devId):
            return [K.APIParameterKey.devId: devId]
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        urlRequest.setValue(K.APIToken.token, forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}
