//
//  Alarm.swift
//  Alarm
//
//  Created by Mahir Jhaveri  on 1/12/19.
//  Copyright © 2019 Mahir Jhaveri . All rights reserved.
//

import Foundation

// The model for the Alarm app
class Alarm  {
    
    private var hasAlarm: Bool = false
    private var alarmTime: Date? = nil // Optional containing the alarm time or nil
                                       // if no alarm has been set
    
    func getAlarmTime() -> Date? {
        return alarmTime
    }
    
    // Assumes that time is always going to be valid
    func setAlarmTime(to time: Date) {
        hasAlarm = true
        alarmTime = Optional(time)
    }
    
    func removeAlarm() {
        hasAlarm = false
        alarmTime = nil
    }
    
    func alarmPresent() -> Bool {
        return hasAlarm
    }
    
}
