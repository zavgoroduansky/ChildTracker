//
//  DataManager.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/13/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import Foundation

// MARK: Setup
class DataManager {
    
    func setupLocationTypes() -> Bool {
        
        var locationTypes = [DBLocation]()
        locationTypes.append(DBLocation(location: .outside))
        
        return RealmManager.setupLocationTypes(locationTypes)
    }
    
    func setupStateTypes() -> Bool {
        
        var stateTypes = [DBState]()
        stateTypes.append(DBState(state: .sleep))
        stateTypes.append(DBState(state: .feeding))
        stateTypes.append(DBState(state: .bathing))
        
        return RealmManager.setupStateTypes(stateTypes)
    }
    
    func setupSideTypes() -> Bool {
        
        var sideTypes = [DBSide]()
        sideTypes.append(DBSide(side: .left))
        sideTypes.append(DBSide(side: .right))
        
        return RealmManager.setupSideTypes(sideTypes)
    }
    
    func setupConditionTypes() -> Bool {
        
        var conditionTypes = [DBCondition]()
        conditionTypes.append(DBCondition(condition: .active))
        conditionTypes.append(DBCondition(condition: .paused))
        conditionTypes.append(DBCondition(condition: .finished))
        
        return RealmManager.setupConditionTypes(conditionTypes)
    }
}

// MARK: Location
extension DataManager {
    
    func currentLocation(completion: @escaping (Location, Date?) -> Void) {
        
        RealmManager.currentLocation { (realmLocationTracker) in
            completion(self.convertDBLocation(realmLocationTracker?.location) ?? .home, realmLocationTracker?.start ?? nil)
        }
    }
    
    func startNewLocation(_ location: Location, completion: @escaping (Bool) -> Void) {
        
        // firstly - need to check that current location was closed
        if let lastLocation = RealmManager.lastLocation() {
            // need to check it
            if let lastLocationId = lastLocation.location?.id {
                if lastLocationId != location.rawValue {
                    finishCurrentLocation { (success) in
                        if success {
                            RealmManager.trackNewLocation(DBLocation(location: location), startDate: Date(), completion: { (success) in
                                completion(success)
                            })
                        } else {
                            completion(false)
                        }
                    }
                } else {
                    // no need to open new location becouse it already opened
                }
            } else {
                // can't hapened ever but close it
                finishCurrentLocation { (success) in
                    if success {
                        RealmManager.trackNewLocation(DBLocation(location: location), startDate: Date(), completion: { (success) in
                            completion(success)
                        })
                    } else {
                        completion(false)
                    }
                }
            }
        } else {
            // there is no opened location
            RealmManager.trackNewLocation(DBLocation(location: location), startDate: Date(), completion: { (success) in
                completion(success)
            })
        }
    }
    
    func finishCurrentLocation(completion: @escaping (Bool) -> Void) {
        
        RealmManager.finishCurrentLocation(date: Date()) { (success) in
            completion(success)
        }
    }
    
    func totalDurationFor(location: Location, completion: @escaping (Double) -> Void) {
        
        RealmManager.fetchTotalDurationFor(locationId: location.rawValue) { (duration) in
            completion(duration)
        }
    }
}

// MARK: State
extension DataManager {
    
    func currentState(completion: @escaping (StateLine, Date?) -> Void) {
        
        RealmManager.currentState { (realmStateTracker) in
            completion(self.convertDBStateTracker(realmStateTracker), realmStateTracker?.start ?? nil)
        }
    }
    
    func detailedHistoryStates(completion: @escaping ([StateLine]) -> Void) {
        
        var statesId = [Int]()
        State.allCases.forEach { (state) in
            if state.showDetailViews() {
                statesId.append(state.rawValue)
            }
        }
        
        RealmManager.detailedHistoryStates(statesId: statesId) { (realmStateTrackerArray) in
            var result = [StateLine]()
            
            for track in realmStateTrackerArray {
                result.append(self.convertDBStateTracker(track))
            }
            completion(result)
        }
    }
    
    func startNewState(_ state: State, side: Side?, completion: @escaping (Bool) -> Void) {
        
        // firstly - need to check that current state was closed
        if let lastState = RealmManager.lastState() {
            // need to check it
            if let lastStateId = lastState.state?.id {
                if lastStateId != state.rawValue {
                    finishCurrentState { (success) in
                        
                        if success {
                            RealmManager.trackNewState(DBState(state: state), startDate: Date(), side: side == nil ? nil : DBSide(side: side!), completion: { (success) in
                                completion(success)
                            })
                        } else {
                            completion(false)
                        }
                    }
                } else {
                    // no need to open new state becouse it already opened
                }
            } else {
                // can't hapened ever but close it
                finishCurrentState { (success) in
                    if success {
                        RealmManager.trackNewState(DBState(state: state), startDate: Date(), side: side == nil ? nil : DBSide(side: side!), completion: { (success) in
                            completion(success)
                        })
                    } else {
                        completion(false)
                    }
                }
            }
        } else {
            // there is no opened state
            RealmManager.trackNewState(DBState(state: state), startDate: Date(), side: side == nil ? nil : DBSide(side: side!), completion: { (success) in
                completion(success)
            })
        }
    }
    
    func finishCurrentState(completion: @escaping (Bool) -> Void) {
        
        RealmManager.finishCurrentState(date: Date()) { (success) in
            completion(success)
        }
    }
    
    func pauseCurrentState(date: Date, completion: @escaping (Bool) -> Void) {
        
        RealmManager.pauseCurrentState(date: date) { (success) in
            completion(success)
        }
    }
    
    func resumeCurrentState(startDate: Date, side: Side?, completion: @escaping (Bool) -> Void) {
        
        RealmManager.resumeCurrentState(startDate: startDate, side: side == nil ? nil : DBSide(side: side!)) { (success) in
            completion(success)
        }
    }
    
    func totalStatesDurations(completion: @escaping ([State : Double]) -> Void) {
        
        RealmManager.fetchTotalDurationFor(statesId: [State.sleep.rawValue, State.feeding.rawValue, State.bathing.rawValue]) { (result) in
            var answer = [State: Double]()
            for line in result {
                if let state = State.init(rawValue: line.key) {
                    answer[state] = line.value
                }
            }
            completion(answer)
        }
    }
}

// MARK: private
private extension DataManager {
    
    func convertDBStateTracker(_ stateTracker: DBStateTracker?) -> StateLine {
        
        guard let existedStateTracker = stateTracker else {
            return StateLine()
        }
        
        guard let state = convertDBState(existedStateTracker.state) else {
            return StateLine()
        }
        
        guard let condition = convertDBCondition(existedStateTracker.condition) else {
            return StateLine()
        }
        
        return StateLine(state: state, duration: stateTracker?.lines.sum(ofProperty: "duration") ?? 0, side: convertDBSide(existedStateTracker.lines.last?.side), condition: condition)
    }
    
    func convertDBLocation(_ location: DBLocation?) -> Location? {
        
        guard let existedLocation = location else {
            return nil
        }
        
        return Location(rawValue: existedLocation.id)
    }
    
    func convertDBState(_ state: DBState?) -> State? {
        
        guard let existedState = state else {
            return nil
        }
        
        return State(rawValue: existedState.id)
    }
    
    func convertDBSide(_ side: DBSide?) -> Side? {
        
        guard let existedSide = side else {
            return nil
        }
        
        return Side(rawValue: existedSide.id)
    }
    
    func convertDBCondition(_ condition: DBCondition?) -> Condition? {
        
        guard let existedCondition = condition else {
            return nil
        }
        
        return Condition(rawValue: existedCondition.id)
    }
}
