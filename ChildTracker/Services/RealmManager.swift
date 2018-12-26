//
//  RealmManager.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/13/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmManager {
    
    // MARK: Properties
    private static let realmQueue = DispatchQueue(label: "RealmQueue", attributes: .concurrent)
}

// MARK: initial
extension RealmManager {
    
    static func setupLocationTypes(_ types: [DBLocation]) -> Bool {
        return updateTypesArray(types)
    }
    
    static func setupStateTypes(_ types:[DBState]) -> Bool {
        return updateTypesArray(types)
    }
    
    static func setupSideTypes(_ types: [DBSide]) -> Bool {
        return updateTypesArray(types)
    }
    
    static func setupConditionTypes(_ types: [DBCondition]) -> Bool {
        return updateTypesArray(types)
    }
    
    static func setupDeficationTypes(_ types: [DBDeficationType]) -> Bool {
        return updateTypesArray(types)
    }
}

// MARK: location
extension RealmManager {
    
    static func currentLocation(completion: @escaping (DBLocationTracker?) -> Void) {
        
        realmQueue.async {
            completion(RealmManager.lastLocation())
        }
    }
    
    static func trackNewLocation(_ location: DBLocation, startDate: Date, completion: @escaping (Bool) -> Void) {
        
        realmQueue.async {
            let realm = try! Realm()
            if let realmLocation = realm.object(ofType: DBLocation.self, forPrimaryKey: location.id) {
                try! realm.write {
                    realm.create(DBLocationTracker.self, value: DBLocationTracker(location: realmLocation, startDate: startDate), update: false)
                }
            }
            completion(true)
        }
    }
    
    static func finishCurrentLocation(date: Date, completion: @escaping (Bool) -> Void) {
        
        realmQueue.async {
            let realm = try! Realm()
            if let lastLocation = RealmManager.lastLocation() {
                // need to close opened location
                try! realm.write {
                    lastLocation.finish = date
                    lastLocation.duration = date.timeIntervalSince(lastLocation.start)
                    completion(true)
                }
            } else {
                // there is no object
                completion(true)
            }
        }
    }
    
    static func fetchTotalDurationFor(locationId: Int, startDate: Date?, endDate: Date?, completion: @escaping (Double) -> Void) {
        
        let predicateFormat = "location.id = \(locationId) AND duration > 0" + prepareStartFinishPredicateFormatString(startDate: startDate, endDate: endDate)
        
        let predicate = NSPredicate(format: predicateFormat)
        var duration: TimeInterval = 0
        
        realmQueue.async {
            let realm = try! Realm()
            
            let result = realm.objects(DBLocationTracker.self).filter(predicate).sorted(byKeyPath: "start", ascending: true)
            autoreleasepool {
                for line in result {
                    let startLine = (startDate == nil ? line.start : max(line.start, startDate!))
                    let finishLine = (endDate == nil ? line.finish! : min(line.finish!, endDate!))
                    
                    // need to calculate new duration
                    duration += finishLine.timeIntervalSince(startLine)
                }
            }
            completion(duration)
        }
    }
}

// MARK: state
extension RealmManager {
    
    static func currentState(completion: @escaping (DBStateTracker?) -> Void) {
        
        realmQueue.async {
            completion(RealmManager.lastState())
        }
    }
    
    static func detailedHistoryStates(statesId: [Int], completion: @escaping ([DBStateTracker]) -> Void) {
        
        var result = [DBStateTracker]()
        
        realmQueue.async {
            let realm = try! Realm()
            for id in statesId {
                let predicate = NSPredicate(format: "state.id = %i AND condition.id = %i", id, Condition.finished.rawValue)
                if let stateTracker = realm.objects(DBStateTracker.self).filter(predicate).sorted(byKeyPath: "start", ascending: false).first {
                    result.append(stateTracker)
                }
            }
            completion(result)
        }
    }
    
    static func trackNewState(_ state: DBState, startDate: Date, side: DBSide?, completion: @escaping (Bool) -> Void) {
        
        realmQueue.async {
            let realm = try! Realm()
            if let realmState = realm.object(ofType: DBState.self, forPrimaryKey: state.id) {
                let realmSide = side == nil ? nil : realm.object(ofType: DBSide.self, forPrimaryKey: side?.id)
                let realmCondition = realm.object(ofType: DBCondition.self, forPrimaryKey: Condition.active.rawValue)!
                try! realm.write {
                    // create line
                    let newLine = realm.create(DBStateTrackerLine.self, value: DBStateTrackerLine(startDate: startDate, side: realmSide), update: false)
                    let newState = realm.create(DBStateTracker.self, value: DBStateTracker(state: realmState, condition: realmCondition, startDate: startDate), update: false)
                    newState.lines.append(newLine)
                }
            }
            completion(true)
        }
    }
    
    static func finishCurrentState(date: Date, completion: @escaping (Bool) -> Void) {
        
        realmQueue.async {
            let realm = try! Realm()
            if let lastState = RealmManager.lastState() {
                try! realm.write {
                    if let condition = lastState.condition {
                        if condition.id == Condition.paused.rawValue {
                            // just need to set finish condition
                            lastState.condition = realm.object(ofType: DBCondition.self, forPrimaryKey: Condition.finished.rawValue)!
                            // need to get last state line and set finish date from it
                            if let lastLine = lastState.lines.sorted(byKeyPath: "start", ascending: false).first {
                                lastState.finish = lastLine.finish
                            } else {
                                // this is not so good becouse we need to set finish date from last line but not from current date
                                lastState.finish = date
                            }
                        } else {
                            // need to close active state
                            if let lastLine = lastState.lines.last {
                                lastLine.finish = date
                                lastLine.duration = date.timeIntervalSince(lastLine.start)
                                
                                lastState.condition = realm.object(ofType: DBCondition.self, forPrimaryKey: Condition.finished.rawValue)!
                                lastState.finish = date
                            }
                        }
                    }
                    completion(true)
                }
            } else {
                // there is no object
                completion(true)
            }
        }
    }
    
    static func pauseCurrentState(date: Date, completion: @escaping (Bool) -> Void) {
        
        realmQueue.async {
            let realm = try! Realm()
            if let lastState = RealmManager.lastState(), lastState.condition?.id == Condition.active.rawValue {
                try! realm.write {
                    if let lastLine = lastState.lines.last {
                        lastLine.finish = date
                        lastLine.duration = date.timeIntervalSince(lastLine.start)
                        
                        lastState.condition = realm.object(ofType: DBCondition.self, forPrimaryKey: Condition.paused.rawValue)!
                    }
                }
                completion(true)
            } else {
                // there is no object
                completion(false)
            }
        }
    }
    
    static func resumeCurrentState(startDate: Date, side: DBSide?, completion: @escaping (Bool) -> Void) {
        
        realmQueue.async {
            let realm = try! Realm()
            if let lastState = RealmManager.lastState(), lastState.condition?.id == Condition.paused.rawValue {
                let realmSide = side == nil ? nil : realm.object(ofType: DBSide.self, forPrimaryKey: side?.id)
                try! realm.write {
                    let newLine = realm.create(DBStateTrackerLine.self, value: DBStateTrackerLine(startDate: startDate, side: realmSide), update: false)
                    lastState.lines.append(newLine)
                    
                    lastState.condition = realm.object(ofType: DBCondition.self, forPrimaryKey: Condition.active.rawValue)!
                }
            } else {
                // there is no object
                completion(false)
            }
        }
    }
    
    static func fetchTotalDurationFor(statesId: [Int], startDate: Date?, endDate: Date?, completion: @escaping ([Int: Double]) -> Void) {
        
        var resultDictionary = [Int: Double]()
        
        realmQueue.async {
            let realm = try! Realm()
            autoreleasepool {
                for id in statesId {
                    var duration: Double = 0
                    
                    let predicateFormat = String(format: "state.id = %i AND condition.id = %i", id, Condition.finished.rawValue) + prepareStartFinishPredicateFormatString(startDate: startDate, endDate: endDate)
                    let predicate = NSPredicate(format: predicateFormat)
                    
                    let result = realm.objects(DBStateTracker.self).filter(predicate).sorted(byKeyPath: "start", ascending: true)
                    for stateLine in result {
                        for line in stateLine.lines {
                            let startLine = (startDate == nil ? line.start : max(line.start, startDate!))
                            let finishLine = (endDate == nil ? line.finish! : min(line.finish!, endDate!))
                            
                            // need to calculate new duration
                            duration += finishLine.timeIntervalSince(startLine)
                        }
                    }
                    resultDictionary[id] = duration
                }
            }
            completion(resultDictionary)
        }
    }
}

// MARK: Actions
extension RealmManager {
    
    static func trackNewDefication(_ deficationType: DBDeficationType, date: Date, comment: String?, completion: @escaping (Bool) -> Void) {
        
        realmQueue.async {
            let realm = try! Realm()
            if let realmDeficationType = realm.object(ofType: DBDeficationType.self, forPrimaryKey: deficationType.id) {
                try! realm.write {
                    realm.create(DBDeficationTracker.self, value: DBDeficationTracker(type: realmDeficationType, startDate: date, comment: comment), update: false)
                }
            }
            completion(true)
        }
    }
    
    static func fetchTotalDurationFor(deficationId: [Int], startDate: Date?, endDate: Date?, completion: @escaping ([Int: Int]) -> Void) {
        
        var resultDictionary = [Int: Int]()
        
        realmQueue.async {
            let realm = try! Realm()
            autoreleasepool {
                for id in deficationId {
        
                    let predicateFormat = String(format: "type.id = %i", id) + prepareDatePredicateFormatString(startDate: startDate, endDate: endDate)
                    let predicate = NSPredicate(format: predicateFormat)
                    
                    let quantity = realm.objects(DBDeficationTracker.self).filter(predicate).count
                    resultDictionary[id] = quantity
                }
            }
            completion(resultDictionary)
        }
    }
}

// MARK: info
extension RealmManager {
    
    static func lastLocation() -> DBLocationTracker? {
        
        let realm = try! Realm()
        if let lastLocation = realm.objects(DBLocationTracker.self).sorted(byKeyPath: "start", ascending: false).first, lastLocation.finish == nil {
            return lastLocation
        } else {
            return nil
        }
    }
    
    static func lastState() -> DBStateTracker? {
        
        let realm = try! Realm()
        if let lastState = realm.objects(DBStateTracker.self).sorted(byKeyPath: "start", ascending: false).first, lastState.condition?.id != Condition.finished.rawValue {
            return lastState
        }
        return nil
    }
}

// MARK: Private
private extension RealmManager {
    
    static func updateTypesArray(_ types: [Object]) -> Bool {
        
        realmQueue.async {
            let realm = try! Realm()
            try! realm.write {
                realm.add(types, update: true)
            }
        }
        return true
    }
    
    static func prepareStartFinishPredicateFormatString(startDate: Date?, endDate: Date?) -> String {
        
        var predicateFormat = ""
        
        if let start = startDate, let finish = endDate {
            predicateFormat.append(" AND (")
            predicateFormat.append(NSPredicate(format: "(start > %@ AND finish < %@)", start as CVarArg, finish as CVarArg).predicateFormat)
            predicateFormat.append(" OR ")
            predicateFormat.append(NSPredicate(format: "(start > %@ AND start < %@)", start as CVarArg, finish as CVarArg).predicateFormat)
            predicateFormat.append(" OR ")
            predicateFormat.append(NSPredicate(format: "(finish > %@ AND finish < %@)", start as CVarArg, finish as CVarArg).predicateFormat)
            predicateFormat.append(" OR ")
            predicateFormat.append(NSPredicate(format: "(start < %@ AND finish > %@)", start as CVarArg, finish as CVarArg).predicateFormat)
            predicateFormat.append(")")
        } else if let start = startDate {
            predicateFormat.append(" AND (")
            predicateFormat.append(NSPredicate(format: "(start < %@ AND finish > %@)", start as CVarArg).predicateFormat)
            predicateFormat.append(" OR ")
            predicateFormat.append(NSPredicate(format: "(start > %@)", start as CVarArg).predicateFormat)
            predicateFormat.append(")")
        } else if let finish = endDate {
            predicateFormat.append(" AND (")
            predicateFormat.append(NSPredicate(format: "(start < %@ AND finish > %@)", finish as CVarArg).predicateFormat)
            predicateFormat.append(" OR ")
            predicateFormat.append(NSPredicate(format: "(start < %@)", finish as CVarArg).predicateFormat)
            predicateFormat.append(")")
        }
        
        return predicateFormat
    }
    
    static func prepareDatePredicateFormatString(startDate: Date?, endDate: Date?) -> String {
    
        var predicateFormat = ""
        
        if let start = startDate, let finish = endDate {
            predicateFormat.append(" AND (")
            predicateFormat.append(NSPredicate(format: "(date > %@ AND date < %@)", start as CVarArg, finish as CVarArg).predicateFormat)
            predicateFormat.append(")")
        } else if let start = startDate {
            predicateFormat.append(" AND (")
            predicateFormat.append(NSPredicate(format: "(date > %@)", start as CVarArg).predicateFormat)
            predicateFormat.append(")")
        } else if let finish = endDate {
            predicateFormat.append(" AND (")
            predicateFormat.append(NSPredicate(format: "(date < %@)", finish as CVarArg).predicateFormat)
            predicateFormat.append(")")
        }
        
        return predicateFormat
    }
}
