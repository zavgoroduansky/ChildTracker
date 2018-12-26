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
    static let timeIntervalWeek: Double = 60*60*24*7
    private static var gregorianCalender: Calendar {
        var calendar = Calendar.init(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }
    
    var startOfDay: Date {
        return Date.gregorianCalender.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Date.gregorianCalender.date(byAdding: components, to: startOfDay)!
    }
    
    var startOfWeek: Date? {
        guard let sunday = Date.gregorianCalender.date(from: Date.gregorianCalender.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return Date.gregorianCalender.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        guard let sunday = Date.gregorianCalender.date(from: Date.gregorianCalender.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return Date.gregorianCalender.date(byAdding: .day, value: 7, to: sunday)
    }
    
    var startOfMonth: Date {
        let components = Date.gregorianCalender.dateComponents([.year, .month], from: startOfDay)
        return Date.gregorianCalender.date(from: components)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Date.gregorianCalender.date(byAdding: components, to: startOfMonth)!
    }
    
    var datePickerFormatString: String {
        
        let components = Date.gregorianCalender.dateComponents([.month, .day, .hour, .minute], from: self)
        
        var prefix = String(format: "%02d.%02d", components.day ?? 0, components.month ?? 0)
        if Date.gregorianCalender.isDateInToday(self) {
            prefix = "Today"
        } else if Date.gregorianCalender.isDateInTomorrow(self) {
            prefix = "Tomorrow"
        } else if Date.gregorianCalender.isDateInYesterday(self) {
            prefix = "Yesterday"
        }
        
        return String(format: "%@ %02d:%02d", prefix, components.hour ?? 0, components.minute ?? 0)
    }
    
    var numberOfPassedCalendarComponents: DateComponents {
        return Date.gregorianCalender.dateComponents([.day, .month, .year], from: self, to: Date())
    }
}
