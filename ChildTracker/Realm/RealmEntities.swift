//
//  RealmEntities.swift
//  ChildTracker
//
//  Created by Oleg Zavgorodianskyi on 11/13/18.
//  Copyright © 2018 Oleg Zavgorodianskyi. All rights reserved.
//

import Foundation
import RealmSwift

class DBSide: Object {
    
    @objc dynamic var id = 0    // for connection to enum
    @objc dynamic var name = "" // from enum
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(side: Side) {
        self.init()
        
        id      = side.rawValue
        name    = side.title()
    }
}

class DBLocation: Object {
    
    @objc dynamic var id = 0    // for connection to enum
    @objc dynamic var name = "" // from enum
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(location: Location) {
        self.init()
        
        id      = location.rawValue
        name    = location.title()
    }
}

class DBLocationTracker: Object {
    
    @objc dynamic var location: DBLocation?
    @objc dynamic var start = Date()
    @objc dynamic var finish: Date? = nil
    @objc dynamic var duration: Double = 0
    
    convenience init(location: DBLocation, startDate: Date) {
        self.init()
        
        self.location   = location
        self.start      = startDate
    }
}

class DBState: Object {
    
    @objc dynamic var id = 0    // for connection to enum
    @objc dynamic var name = "" // from enum
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(state: State) {
        self.init()
        
        id      = state.rawValue
        name    = state.title()
    }
}

class DBCondition: Object {
    
    @objc dynamic var id = 0    // for connection to enum
    @objc dynamic var name = "" // from enum
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(condition: Condition) {
        self.init()
        
        id      = condition.rawValue
        name    = condition.title()
    }
}

class DBStateTracker: Object {
    
    @objc dynamic var state: DBState?
    @objc dynamic var condition: DBCondition?   // condition based on the last DBStateTrackerLine
    @objc dynamic var start = Date()            // start date based on the first DBStateTrackerLine. need for sorting list of DBStateTracker
    @objc dynamic var finish: Date? = nil       // finish date based on the last DBStateTrackerLine. need for fetching data for reports
    let lines = List<DBStateTrackerLine>()
    
    convenience init(state: DBState, condition: DBCondition, startDate: Date) {
        self.init()
        
        self.state = state
        self.condition = condition
    }
}

class DBStateTrackerLine: Object {
    
    @objc dynamic var start = Date()
    @objc dynamic var finish: Date? = nil
    @objc dynamic var duration: Double = 0
    @objc dynamic var side: DBSide?
    
    convenience init(startDate: Date, side: DBSide?) {
        self.init()
        
        self.start = startDate
        self.side  = side
    }
}

class DBDeficationType: Object {
    
    @objc dynamic var id = 0    // for connection to enum
    @objc dynamic var name = "" // from enum
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(type: DeficationType) {
        self.init()
        
        id      = type.rawValue
        name    = type.title()
    }
}

class DBDeficationTracker: Object {

    @objc dynamic var type: DBDeficationType?
    @objc dynamic var date = Date()
    @objc dynamic var comment: String?

    convenience init(type: DBDeficationType, startDate: Date, comment: String?) {
        self.init()

        self.type       = type
        self.date       = startDate
        self.comment    = comment
    }
}

class DBTemperatureTracker: Object {
    
    @objc dynamic var temperature: Double = 0.0
    @objc dynamic var date = Date()
    @objc dynamic var comment: String?
    
    convenience init(temperature: Double, startDate: Date, comment: String?) {
        self.init()
        
        self.temperature    = temperature
        self.date           = startDate
        self.comment        = comment
    }
}
