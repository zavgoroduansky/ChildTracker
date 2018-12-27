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
    
    func setupDeficationTypes() -> Bool {
        
        var deficationTypes = [DBDeficationType]()
        deficationTypes.append(DBDeficationType(type: .wet))
        deficationTypes.append(DBDeficationType(type: .dirty))
        deficationTypes.append(DBDeficationType(type: .mixed))
        
        return RealmManager.setupDeficationTypes(deficationTypes)
    }
}

// MARK: Location
extension DataManager {
    
    func currentLocation(completion: @escaping (Location, Date?) -> Void) {
        
        RealmManager.currentLocation { (realmLocationTracker) in
            completion(DataManager.convertDBLocation(realmLocationTracker?.location) ?? .home, realmLocationTracker?.start ?? nil)
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
    
    func totalDurationFor(location: Location, interval: Intervals, completion: @escaping (Double) -> Void) {
        
        // need to get interval
        let dateInterval = interval.startDateFinishDate()
        
        RealmManager.fetchTotalDurationFor(locationId: location.rawValue, startDate: dateInterval.start, endDate: dateInterval.finish) { (duration) in
            completion(duration)
        }
    }
}

// MARK: State
extension DataManager {
    
    func currentState(completion: @escaping (StateLine, Date?) -> Void) {
        
        RealmManager.currentState { (realmStateTracker) in
            completion(DataManager.convertDBStateTracker(realmStateTracker), realmStateTracker?.start ?? nil)
        }
    }
    
    func detailedHistoryStates(_ states: [State], completion: @escaping ([StateLine]) -> Void) {
        
        // convert to int
        var statesArray = [Int]()
        for state in states {
            statesArray.append(state.rawValue)
        }
        
        RealmManager.detailedHistoryStates(statesId: statesArray) { (realmStateTrackerArray) in
            var result = [StateLine]()
            
            for track in realmStateTrackerArray {
                result.append(DataManager.convertDBStateTracker(track))
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
    
    func totalStatesDurations(interval: Intervals, completion: @escaping ([State : Double]) -> Void) {
        
        // need to get interval
        let dateInterval = interval.startDateFinishDate()
        
        RealmManager.fetchTotalDurationFor(statesId: [State.sleep.rawValue, State.feeding.rawValue, State.bathing.rawValue], startDate: dateInterval.start, endDate: dateInterval.finish) { (result) in
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

// MARK: Actions
extension DataManager {
    
    func addNewDefication(_ defication: DeficationType, date: Date, comment: String?, completion: @escaping (Bool) -> Void) {
        
        RealmManager.trackNewDefication(DBDeficationType(type: defication), date: date, comment: comment) { (success) in
            completion(success)
        }
    }
    
    func deficationTotalActivity(interval: Intervals, completion: @escaping ([DeficationType : Int]) -> Void) {
    
        // need to get interval
        let dateInterval = interval.startDateFinishDate()
        
        RealmManager.fetchTotalDurationFor(deficationId: [DeficationType.wet.rawValue, DeficationType.dirty.rawValue, DeficationType.mixed.rawValue], startDate: dateInterval.start, endDate: dateInterval.finish) { (result) in
            var answer = [DeficationType: Int]()
            for line in result {
                if let type = DeficationType.init(rawValue: line.key) {
                    answer[type] = line.value
                }
            }
            completion(answer)
        }
    }
    
    func detailedHistoryDefications(_ defications: [DeficationType], completion: @escaping ([DeficationType : NewAction]) -> Void) {

        // convert to int
        var deficationsArray = [Int]()
        for defication in defications {
            deficationsArray.append(defication.rawValue)
        }

        RealmManager.detailedHistoryDefications(deficationsId: deficationsArray) { (realmDeficationTrackerArray) in
            var result = [DeficationType : NewAction]()

            for track in realmDeficationTrackerArray {
                
                guard let deficationType = DataManager.convertDBDeficationType(track.type) else {
                    continue
                }
                
                result[deficationType] = NewAction(date: track.date, comment: track.comment ?? "")
            }
            completion(result)
        }
    }
}

// MARK: private
private extension DataManager {
    
    static func convertDBStateTracker(_ stateTracker: DBStateTracker?) -> StateLine {
        
        guard let existedStateTracker = stateTracker else {
            return StateLine()
        }
        
        guard let state = convertDBState(existedStateTracker.state) else {
            return StateLine()
        }
        
        guard let condition = convertDBCondition(existedStateTracker.condition) else {
            return StateLine()
        }
        
        return StateLine(state: state, startDate: existedStateTracker.start, duration: stateTracker?.lines.sum(ofProperty: "duration") ?? 0, side: convertDBSide(existedStateTracker.lines.last?.side), condition: condition)
    }
    
    static func convertDBLocation(_ location: DBLocation?) -> Location? {
        
        guard let existedLocation = location else {
            return nil
        }
        
        return Location(rawValue: existedLocation.id)
    }
    
    static func convertDBState(_ state: DBState?) -> State? {
        
        guard let existedState = state else {
            return nil
        }
        
        return State(rawValue: existedState.id)
    }
    
    static func convertDBSide(_ side: DBSide?) -> Side? {
        
        guard let existedSide = side else {
            return nil
        }
        
        return Side(rawValue: existedSide.id)
    }
    
    static func convertDBCondition(_ condition: DBCondition?) -> Condition? {
        
        guard let existedCondition = condition else {
            return nil
        }
        
        return Condition(rawValue: existedCondition.id)
    }
    
    static func convertDBDeficationType(_ deficationType: DBDeficationType?) -> DeficationType? {
        
        guard let existedDeficationType = deficationType else {
            return nil
        }
        
        return DeficationType(rawValue: existedDeficationType.id)
    }
}
