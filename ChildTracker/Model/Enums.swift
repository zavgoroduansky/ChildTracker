//
//  Enums.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/12/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import Foundation

// report intervals
enum Intervals: Int {
    
    case last12hours
    case last24hours
    case day
    case week
    case month
    
    static func numberOfElements() -> Int {
        return 4
    }
    
    func title() -> String {
        switch self {
        case .last12hours:
            return "12 hours"
        case .last24hours:
            return "24 hours"
        case .day:
            return "Day"
        case .week:
            return "Week"
        case .month:
            return "Month"
        }
    }
    
    func startDateFinishDate() -> (start: Date?, finish: Date?) {
        
        let currentDate = Date()
        let currentDateTimeInterval = currentDate.timeIntervalSince1970
        
        switch self {
        case .last12hours:
            return (Date(timeIntervalSince1970: currentDateTimeInterval - 12*60*60), currentDate)
        case .last24hours:
            return (Date(timeIntervalSince1970: currentDateTimeInterval - 24*60*60), currentDate)
        case .day:
            return (currentDate.startOfDay, currentDate.endOfDay)
        case .week:
            return (currentDate.startOfWeek, currentDate.endOfWeek)
        case .month:
            return (currentDate.startOfMonth, currentDate.endOfMonth)
        }
    }
}

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
