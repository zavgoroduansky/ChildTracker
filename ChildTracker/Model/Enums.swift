//
//  Enums.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/12/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import Foundation

// condition (using for realm state condition and button state)
enum Condition: Int {
    
    case active = 0
    case paused
    case finished
    
    func title() -> String {
        switch self {
        case .active:
            return "Active"
        case .paused:
            return "Paused"
        case .finished:
            return "Finished"
        }
    }
    
    func opositCondition() -> Condition? {
        
        switch self {
        case .active:
            return .paused
        case .paused:
            return .active
        default:
            return nil
        }
    }
}

// feeding side
enum Side: Int {
    
    case left = 0
    case right
    
    func title() -> String {
        switch self {
        case .left:
            return "Left"
        case .right:
            return "Right"
        }
    }
}

// available location of child
enum Location: Int {
    
    case home = 0   // default location
    case outside
    
    func title() -> String {
        switch self {
        case .home:
            return "Home"
        case .outside:
            return "Outside"
        }
    }
}

// available state of child
enum State: Int {
    
    case activity = 0   // default state
    case sleep
    case feeding
    case bathing
    
    static func numberOfElements() -> Int {
        return 3
    }
    
    func title() -> String {
        switch self {
        case .activity:
            return "Activity"
        case .sleep:
            return "Sleep"
        case .feeding:
            return "Feeding"
        case .bathing:
            return "Bathing"
        }
    }
    
    func numberOfElementsTo(_ finalState: State) -> Int {
        
        var numberOfElements = 0
        
        if self == finalState {
            return numberOfElements
        }
        
        var startIndex = self.rawValue
        let finalIndex = finalState.rawValue
        while true {
            if startIndex == finalIndex {
                break
            }
            startIndex += 1
            if startIndex > State.numberOfElements() {
                startIndex = 0
            }
            numberOfElements += 1
        }
        return numberOfElements
    }
    
    func showDetailViews() -> Bool {
        switch self {
        case .feeding:
            return true
        default:
            return false
        }
    }
}

extension State: CaseIterable {}
