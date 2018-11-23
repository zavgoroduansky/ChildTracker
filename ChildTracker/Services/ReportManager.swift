//
//  ReportManager.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/16/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import Foundation

class ReportManager {
    
    // MARK: Properties
    public var dataManager: DataManager?
    public var locationData = [LocationReportElement]()
    public var stateData = [StateReportElement]()
    
    convenience init(dataManager: DataManager) {
        self.init()
        
        self.dataManager = dataManager
    }
}

extension ReportManager {
    
    func locationTotalDuration(completion: @escaping (Bool) -> Void) {
        
        dataManager?.totalDurationFor(location: .outside, completion: { [unowned self] (duration) in
            self.locationData.removeAll()
            self.locationData.append(LocationReportElement(location: .outside, duration: duration))
            completion(true)
        })
    }
    
    func stateTotalDuration(completion: @escaping (Bool) -> Void) {
        
        dataManager?.totalStatesDurations(completion: { (result) in
            self.stateData.removeAll()
            for line in result {
                self.stateData.append(StateReportElement(state: line.key, duration: line.value))
            }
            completion(true)
        })
    }
}
