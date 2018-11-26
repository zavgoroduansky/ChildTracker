//
//  UserDefaultManager.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/8/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import Foundation

let childKey            = "child"
let notShowStartPageKey = "notShowStartPage"
let reportIntervalKey   = "reportInterval"

class UserDefaultManager {
    
    static func saveUserData(_ data: Child) {

        let userDefaults = UserDefaults.standard
        userDefaults.set(try? PropertyListEncoder().encode(data), forKey: childKey)

        userDefaults.synchronize()
    }
    
    static func fetchUserData() -> Child? {
        
        let userDefaults = UserDefaults.standard
        if let data = userDefaults.value(forKey:childKey) as? Data {
            
            let child = try? PropertyListDecoder().decode(Child.self, from: data)
            return child
        }
        
        return nil
    }
    
    static func finishFirstLaunch() {
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: notShowStartPageKey)
        
        userDefaults.synchronize()
    }
    
    static func isThisFirstLaunch() -> Bool {
    
        let userDefaults = UserDefaults.standard
        return !userDefaults.bool(forKey: notShowStartPageKey)
    }
    
    static func setReportInterval(_ interval: Intervals) {
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(interval.rawValue, forKey: reportIntervalKey)
        
        userDefaults.synchronize()
    }
    
    static func fetchReportInterval() -> Intervals? {
        
        let userDefaults = UserDefaults.standard
        return Intervals.init(rawValue: userDefaults.integer(forKey: reportIntervalKey))
    }
}
