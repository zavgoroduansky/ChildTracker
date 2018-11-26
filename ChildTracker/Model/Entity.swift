//
//  Child.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/8/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import Foundation

struct Child {
    
    var name: String
    var birthday: Date
    var growth: String
    var weight: String
}

extension Child: Codable { }

struct LocationReportElement {
    
    var location: Location = Location.home
    var duration: Double = 0
}

struct StateReportElement {

    var state: State = State.activity
    var duration: Double = 0
}

struct StateLine: Equatable {
    
    var state: State = State.activity
    var startDate: Date = Date()
    var duration: Double = 0
    var side: Side? = nil
    var condition: Condition = Condition.finished
    
    static func == (lhs: StateLine, rhs: StateLine) -> Bool {
        return lhs.state == rhs.state && lhs.duration == rhs.duration && lhs.side == rhs.side
    }
    
    static func != (lhs: StateLine, rhs: StateLine) -> Bool {
        return lhs.state != rhs.state || lhs.duration != rhs.duration || lhs.side != rhs.side
    }
}
