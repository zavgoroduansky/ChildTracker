//
//  FormatManager.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/13/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import Foundation

class FormatManager {
    
    static func formatDurationInSecondsFor(_ duration: Int) -> String {
        
        let hours = duration / 3600
        let minutes = duration / 60 % 60
        let seconds = duration % 60
        
        return hours > 0 ? String(format:"%02i:%02i:%02i", hours, minutes, seconds) : String(format:"%02i:%02i", minutes, seconds)
    }
}
