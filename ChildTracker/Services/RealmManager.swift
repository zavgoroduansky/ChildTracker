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
    
    static func fetchTotalDurationFor(locationId: Int, completion: @escaping (Double) -> Void) {
        
        let predicate = NSPredicate(format: "location.id = %i", locationId)
        
        realmQueue.async {
            let realm = try! Realm()
            let duration: Double = realm.objects(DBLocationTracker.self).filter(predicate).sum(ofProperty: "duration")
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
                    // need to close active state
                    if let lastLine = lastState.lines.last {
                        lastLine.finish = date
                        lastLine.duration = date.timeIntervalSince(lastLine.start)
                        
                        lastState.condition = realm.object(ofType: DBCondition.self, forPrimaryKey: Condition.finished.rawValue)!
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
                    lastState.start = startDate
                }
            } else {
                // there is no object
                completion(false)
            }
        }
    }
    
    static func fetchTotalDurationFor(statesId: [Int], completion: @escaping ([Int: Double]) -> Void) {
        
        var result = [Int: Double]()
        
        realmQueue.async {
            let realm = try! Realm()
            for id in statesId {
                let predicate = NSPredicate(format: "state.id = %i AND condition.id = %i", id, Condition.finished.rawValue)
                var duration: Double = 0
                for currenState in realm.objects(DBStateTracker.self).filter(predicate).enumerated() {
                    duration += currenState.element.lines.sum(ofProperty: "duration")
                }
                result[id] = duration
            }
            completion(result)
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
}
