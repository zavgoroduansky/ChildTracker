//
//  ActivityManager.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/12/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import UIKit

protocol ActivityManagerDelegate: AnyObject {
    
    func setLocation(_ location: Location)
    func setStateLine(_ stateLine: StateLine)
    func updateDetailedStateLines(_ stateLines: [StateLine])
    func locationTimerTick()
    func stateTimerTick()
}

// MARK: Properties
class ActivityManager {

    // MARK: Public properties
    weak var delegate: ActivityManagerDelegate?
    var dataManager: DataManager?
    var location: Location = Location.home {
        didSet {
            if location == .outside {
                startLocationTimer()
            } else {
                killLocationTimer()
            }
        }
    }
    var currentStateLine: StateLine = StateLine() {
        didSet {
            if currentStateLine.state == .activity {
                killStateTimer()
            } else {
                // need to check condition changed if state didn't changed
                if currentStateLine.state == oldValue.state {
                    if currentStateLine.condition != oldValue.condition {
                        switch currentStateLine.condition {
                        case .paused:
                            pauseStateTimer()
                        case .active:
                            resumeStateTimer()
                        default:
                            // bulshit
                            startStateTimer()
                        }
                    }
                } else {
                    switch currentStateLine.condition {
                    case .paused:
                        // resuming from paused state. just update button detail text
                        delegate?.stateTimerTick()
                    default:
                        // this is new state
                        startStateTimer()
                    }
                }
            }
        }
    }
    var locationTimerDuration: Int = 0
    var stateTimerDuration: Int = 0
    
    // MARK: Private properties
    private var locationTimer: Timer?
    private var stateTimer: Timer?
    private var detailTimer: Timer?
    private var activeStateTimerDuration: Int = 0
    
    convenience init(dataManager: DataManager) {
        self.init()
        
        self.dataManager = dataManager
    }
}

// MARK: stop / resume
extension ActivityManager {
    
    func stopAllOperations() {
        
        locationTimer?.invalidate()
        locationTimer = nil
        
        stateTimer?.invalidate()
        stateTimer = nil
        
        detailTimer?.invalidate()
        detailTimer = nil
    }
    
    func resumeAllOperations() {
        
        initCurrentLocation()
        initCurrentState()
        
        detailTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(detailTimerTick), userInfo: nil, repeats: true)
        detailTimer?.fire()
    }
}

// MARK: private
private extension ActivityManager {
    
    func initCurrentLocation() {
        
        dataManager?.currentLocation(completion: { [unowned self] (location, startDate) in
            
            // need to calculate duration
            if location == Location.outside {
                self.locationTimerDuration = self.calculateDurationStartFrom(startDate)
            }
            
            DispatchQueue.main.async { [unowned self] in
                self.location = location
                self.delegate?.setLocation(location)
            }
        })
    }
    
    func initCurrentState() {
        
        dataManager?.currentState(completion: { [unowned self] (stateLine, startDate) in
            
            // need to calculate duration
            if stateLine.state != State.activity {
                if stateLine.condition == .paused {
                    self.stateTimerDuration = Int(stateLine.duration)
                } else {
                    self.activeStateTimerDuration = self.calculateDurationStartFrom(startDate)
                }
            }
            
            DispatchQueue.main.async { [unowned self] in
                self.delegate?.setStateLine(stateLine)
                self.currentStateLine = stateLine
            }
        })
    }
    
    func calculateDurationStartFrom(_ startDate: Date?) -> Int {
        
        guard let existedStartDate = startDate else {
            return 0
        }
        
        let timeInterval = Date().timeIntervalSince(existedStartDate)
        return Int(timeInterval < 0 ? 0 : timeInterval)
    }
    
    func startLocationTimer() {
        
        if locationTimer == nil {
            locationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(locationTimerTick), userInfo: nil, repeats: true)
        }
        locationTimer?.fire()
        
        // save data to db
        dataManager?.startNewLocation(.outside, completion: { (success) in
            
        })
    }
    
    func killLocationTimer() {
        
        locationTimer?.invalidate()
        locationTimer = nil
        locationTimerDuration = 0
        
        // save data to db
        dataManager?.finishCurrentLocation(completion: { (success) in
            
        })
    }
    
    func pauseStateTimer() {
        
        stopStateTimer()
        
        // save data to db
        dataManager?.pauseCurrentState(date: Date(), completion: { (success) in
            
        })
    }
    
    func resumeStateTimer() {
        
        stateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(stateTimerTick), userInfo: nil, repeats: true)
        stateTimer?.fire()
        
        // save data to db
        dataManager?.resumeCurrentState(startDate: Date(), side: currentStateLine.side, completion: { (success) in
            
        })
    }
    
    func startStateTimer() {
        
        stopStateTimer()
        cleanStateTimerDuration()
        
        stateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(stateTimerTick), userInfo: nil, repeats: true)
        stateTimer?.fire()
        
        // save data to db
        dataManager?.startNewState(currentStateLine.state, side: currentStateLine.side, completion: { (success) in
            
        })
    }
    
    func killStateTimer() {
        
        stopStateTimer()
        cleanStateTimerDuration()
        
        // save data to db
        dataManager?.finishCurrentState(completion: { (success) in
            
        })
    }
    
    func stopStateTimer() {
        
        stateTimer?.invalidate()
        stateTimer = nil
    }
    
    func cleanStateTimerDuration() {
        
        stateTimerDuration = 0
        
        // set duration from active when user resume app from background
        stateTimerDuration = activeStateTimerDuration
        activeStateTimerDuration = 0
    }
    
    @objc func locationTimerTick() {
        
        locationTimerDuration += 1
        delegate?.locationTimerTick()
    }
    
    @objc func stateTimerTick() {
        
        stateTimerDuration += 1
        delegate?.stateTimerTick()
    }
    
    @objc func detailTimerTick() {
        
        // need to get history states with side
        dataManager?.detailedHistoryStates(completion: { [unowned self] (stateLineArray) in
            DispatchQueue.main.async { [unowned self] in
                self.delegate?.updateDetailedStateLines(stateLineArray)
            }
        })
    }
}
