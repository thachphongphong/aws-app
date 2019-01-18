//
//  Message.swift
//  aws-app
//
//  Created by Linh Do on 8/16/18.
//  Copyright © 2018 Linh Do. All rights reserved.
//

import Foundation

struct Message : Codable {
    let payload : String?
    let qos : Int?
    let topic : String?
    
}
