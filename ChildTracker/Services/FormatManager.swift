//
//  FormatManager.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/13/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import Foundation

class FormatManager {
    
    static func formatDurationForTimer(_ duration: Int) -> String {
        
        let hours = duration / 3600
        let minutes = duration / 60 % 60
        let seconds = duration % 60
        
        return hours > 0 ? String(format:"%02i:%02i:%02i", hours, minutes, seconds) : String(format:"%02i:%02i", minutes, seconds)
    }
    
    static func formatDurationForDetail(_ duration: Int) -> String {
        
        let minutes = duration / 60 % 60
        return minutes > 0 ? String(format:"%02i min", minutes) : String(format:"%02i sec", duration % 60)
    }
    
    static func formatDayDifference(for date: Date) -> String {
        
        let calendar = NSCalendar.current
        if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else if calendar.isDateInToday(date) {
            return "Today at \(calendar.component(.hour, from: date)):\(calendar.component(.minute, from: date))"
        } else {
            let startOfNow = calendar.startOfDay(for: Date())
            let startOfTimeStamp = calendar.startOfDay(for: date)
            let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
            let day = components.day!
            if day < 1 {
                return "\(abs(day)) days ago"
            } else {
                return "In \(day) days"
            }
        }
    }
}
