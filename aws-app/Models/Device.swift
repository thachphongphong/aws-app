//
//  Device.swift
//  aws-app
//
//  Created by Linh Do on 5/17/19.
//  Copyright © 2019 Linh Do. All rights reserved.
//

import Foundation


class Device: Codable {
    var devId: String?
    var name: String?
    var status: Int = 0
    var power: Int = 0
    var vol: Int = 0
    var cat: String?
    var icon: String?
}
