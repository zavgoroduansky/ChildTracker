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
    public var deficationData = [DeficationReportElement]()
    
    convenience init(dataManager: DataManager) {
        self.init()
        
        self.dataManager = dataManager
    }
}

extension ReportManager {
    
    func locationTotalDuration(interval: Intervals, completion: @escaping (Bool) -> Void) {
        
        dataManager?.totalDurationFor(location: .outside, interval: interval, completion: { [unowned self] (duration) in
            self.locationData.removeAll()
            self.locationData.append(LocationReportElement(location: .outside, duration: duration))
            completion(true)
        })
    }
    
    func stateTotalDuration(interval: Intervals, completion: @escaping (Bool) -> Void) {
        
        dataManager?.totalStatesDurations(interval: interval, completion: { (result) in
            self.stateData.removeAll()
            for line in result {
                self.stateData.append(StateReportElement(state: line.key, duration: line.value))
            }
            completion(true)
        })
    }
    
    func deficationTotalActivity(interval: Intervals, completion: @escaping (Bool) -> Void) {
        
        dataManager?.deficationTotalActivity(interval: interval, completion: { (result) in
            self.deficationData.removeAll()
            let sortedKeys = Array(result.keys).sorted(by: { (first, second) -> Bool in
                return first.rawValue < second.rawValue
            })
            for key in sortedKeys {
                self.deficationData.append(DeficationReportElement(defication: key, quantity: result[key]!))
            }
            completion(true)
        })
    }
}
