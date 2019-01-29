//
//  Alarm.swift
//  ALarm Project
//
//  Created by Nathan Andrus on 1/28/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import Foundation

class Alarm: Codable {
    init(name: String, enabled: Bool, fireDate: Date, uuid: String = UUID().uuidString) {
        self.name = name
        self.enabled = enabled
        self.fireDate = fireDate
        self.uuid = uuid
    }
        
    var fireDate: Date
    var name: String
    var enabled: Bool
    var uuid: String
    
    var fireTimeAsString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter.string(from: fireDate)
    }
}

extension Alarm: Equatable {
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        if lhs.uuid != rhs.uuid {return false}
        return true
    }
}
