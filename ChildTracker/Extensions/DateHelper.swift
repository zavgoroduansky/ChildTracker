//
//  DateHelper.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/23/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import Foundation

extension Date {

    static let timeIntervalDay: Double = 60*60*24
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
    
    var datePickerFormatString: String {
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day, .hour, .minute], from: self)
        
        var prefix = String(format: "%02d.%02d", components.day ?? 0, components.month ?? 0)
        if calendar.isDateInToday(self) {
            prefix = "Today"
        } else if calendar.isDateInTomorrow(self) {
            prefix = "Tomorrow"
        } else if calendar.isDateInYesterday(self) {
            prefix = "Yesterday"
        }
        
        return String(format: "%@ %02d:%02d", prefix, components.hour ?? 0, components.minute ?? 0)
    }
}
