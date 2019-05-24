//
//  APIRouter.swift
//  aws-app
//
//  Created by Linh Do on 1/18/19.
//  Copyright © 2019 Linh Do. All rights reserved.
//

import Alamofire

enum APIRouter: URLRequestConvertible {
    
    case switchDevice(devId:String, status:Int)
    case statusAll
    case status(devId: String)
    case getDevice
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .switchDevice:
            return .post
        case .statusAll, .status, .getDevice:
            return .get
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .switchDevice(let devId, _):
            return "/api/v1.0/\(devId)"
        case .statusAll:
            return "/api/v1.0/status"
        case .status(let devId):
            return "/api/v1.0/\(devId)"
        case .getDevice:
            return "/api/v1.0/device"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .switchDevice( _, let status):
            return [K.APIParameterKey.status: status]
        case .statusAll, .status, .getDevice:
            return nil
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
        urlRequest.setValue(K.APIUserId.id, forHTTPHeaderField: HTTPHeaderField.userId.rawValue)
        
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
