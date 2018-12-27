//
//  DictionaryHelper.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 12/27/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import Foundation

extension Dictionary {
    
    mutating func merge(dict: [Key: Value]) {
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
