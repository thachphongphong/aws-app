//
//  Preferences.swift
//  aws-app
//
//  Created by Linh Do on 5/29/18.
//  Copyright © 2018 Linh Do. All rights reserved.
//

import Foundation

fileprivate let kLocalNetworkKey = "Preferences.LocalNetwork"
fileprivate let kAutoMode = "Preferences.AutoMode"

class Preferences {
    static let shared = Preferences()
    
    var isLocalNetwork: Bool {
        get {
            return getPrefBool(key: kLocalNetworkKey, def: true) // true by default
        }
        set {
            setPref(bool: newValue, key: kLocalNetworkKey)
        }
    }
    
    var isAutoMode: Bool {
        get {
            return getPrefBool(key: kAutoMode, def: true) // true by default
        }
        set {
            setPref(bool: newValue, key: kAutoMode)
        }
    }
    
    // get bool value from UserDefaults
    private func getPrefBool(key: String, def: Bool) -> Bool {
        let prefs = UserDefaults.standard
        if let boolNumber = prefs.object(forKey: key) as? NSNumber {
            return boolNumber.boolValue
        } else {
            return def
        }
    }
    
    // set bool value to UserDefaults
    private func setPref(bool value: Bool, key: String) {
        let prefs = UserDefaults.standard
        prefs.set(value, forKey: key)
        prefs.synchronize()
    }
}
