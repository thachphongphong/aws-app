//
//  APIClient.swift
//  aws-app
//
//  Created by Linh Do on 1/18/19.
//  Copyright © 2019 Linh Do. All rights reserved.
//

import Alamofire

class APIClient {
    @discardableResult
    private static func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T>)->Void) -> DataRequest {
        return AF.request(route)
            .responseDecodable (decoder: decoder){ (response: DataResponse<T>) in
                completion(response.result)
        }
    }
    
    static func switchDevice(devId: String, completion:@escaping (Result<Status>)->Void) {
        performRequest(route: APIRouter.switchDevice(devId: devId), completion: completion)
    }
    
    static func getAllStatus(completion:@escaping (Result<[Status]>)->Void) {
        performRequest(route: APIRouter.statusAll, completion: completion)
    }
    
    static func getStatus(devId: String, completion:@escaping (Result<Status>)->Void) {
        performRequest(route: APIRouter.status(devId: devId), completion: completion)
    }
}
