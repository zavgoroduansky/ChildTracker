//
//  ChildManager.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/8/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import Foundation

class ChildManager {
    
    public static var child: Child {
        get {
            return fetchChild()
        }
        set (newValue) {
            saveChild(newValue)
        }
    }
    
    private static var internalChild: Child = Child(name: DefaultValues.defaultChildName, birthday: DefaultValues.defaultChildBirthday, growth: DefaultValues.defaultChildGrowth, weight: DefaultValues.defaultChildWeight, image: nil)
    private static var childIsActual = false
}

private extension ChildManager {
 
    private static func saveChild(_ childToSave: Child) {
        
        UserDefaultManager.saveUserData(childToSave)
        internalChild = childToSave
        childIsActual = true
    }
    
    private static func fetchChild() -> Child {
        
        if !childIsActual {
            if let fetchedChild = UserDefaultManager.fetchUserData() {
                internalChild = fetchedChild
            }
        }
        return internalChild
    }
}
