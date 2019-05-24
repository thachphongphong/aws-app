//
//  APIClient.swift
//  aws-app
//
//  Created by Linh Do on 1/18/19.
//  Copyright © 2019 Linh Do. All rights reserved.
//

import Alamofire

struct ResponseDecodable<T> {
    var data: T
    var messabe: String?
}

class APIClient {
    @discardableResult
    private static func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T>)->Void) -> DataRequest {
        return AF.request(route)
            .responseDecodable (decoder: decoder){ (response: DataResponse<T>) in
                completion(response.result)
        }
    }
    
    static func switchDevice(devId: String, status: Int, completion:@escaping (Result<Status>)->Void) {
        performRequest(route: APIRouter.switchDevice(devId: devId, status: status), completion: completion)
    }
    
    static func getAllStatus(completion:@escaping (Result<[Status]>)->Void) {
        performRequest(route: APIRouter.statusAll, completion: completion)
    }
    
    static func getStatus(devId: String, completion:@escaping (Result<Status>)->Void) {
        performRequest(route: APIRouter.status(devId: devId), completion: completion)
    }
    
    static func getDevices(completion:@escaping (Result<[Device]>)->Void) {
        performRequest(route: APIRouter.getDevice, completion: completion)
    }
}
