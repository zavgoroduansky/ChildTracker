//
//  Child.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/8/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import Foundation
import UIKit

struct Child {
    
    var name: String
    var birthday: Date
    var growth: String
    var weight: String
    var image: Data? = nil
    
    var age: String {
        
        var age = ""
        
        let components = birthday.numberOfPassedCalendarComponents
        
        if let numberOfYears = components.year, numberOfYears > 0 {
            age += "\(numberOfYears) years "
        }
        
        if let numberOfMonth = components.month, numberOfMonth > 0 {
            age += "\(numberOfMonth) month "
        }
        
        if let numberOfDays = components.day, numberOfDays > 0 {
            age += "\(numberOfDays) days"
        }
        
        return age
    }
    
    var photo: UIImage? {
        // need to unwrap image
        if let imageData = image {
            return UIImage(data: imageData)
        }
        return nil
    }
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

struct DeficationReportElement {
    
    var defication: DeficationType = DeficationType.wet
    var quantity: Int = 0
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

class NewAction {
    
    var date: Date = Date()
    var comment: String?
    
    convenience init(date: Date, comment: String?) {
        self.init()
        
        self.date       = date
        self.comment    = comment
    }
}

class TemperatureAction: NewAction {
    
    var temperature: Double = 0.0
    
    convenience init(temperature: Double, date: Date, comment: String?) {
        self.init(date: date, comment: comment)
        
        self.temperature = temperature
    }
}
