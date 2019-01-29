//
//  AlarmController.swift
//  ALarm Project
//
//  Created by Nathan Andrus on 1/28/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import Foundation
import UserNotifications

class AlarmController: AlarmScheduler {
    

    //Singleton/Shared Instance
    static let shared = AlarmController()
    
    var alarms: [Alarm] = []
    
    
    //CRUD FUNCTIONS
    func addAlarm(fireDate: Date, name: String, enabled: Bool) {
        let alarm = Alarm(name: name, enabled: enabled, fireDate: fireDate, uuid: UUID().uuidString)
        alarms.append(alarm)
        scheduleUserNotifications(for: alarm)
        saveToPersistentStore()
    }
    
    
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        alarm.name = name
        alarm.enabled = enabled
        alarm.fireDate = fireDate
        saveToPersistentStore()
    }
    
    func delete(alarm: Alarm) {
        guard let alarmIndex = AlarmController.shared.alarms.index(of: alarm) else { return }
            alarms.remove(at: alarmIndex)
        saveToPersistentStore()
        cancelUserNotifications(for: alarm)
    }
    
    func enableToggle(for alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        if alarm.enabled {
            scheduleUserNotifications(for: alarm)
        }
        if !alarm.enabled {
            cancelUserNotifications(for: alarm)
        }
    }

// PERSISTENCE
    private func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "alarm.json"
        let documentsDirectoryURL = urls[0].appendingPathComponent(fileName)
        return documentsDirectoryURL
}

func saveToPersistentStore() {
    let jsonEncoder = JSONEncoder()
    do {
        let alarmData = try jsonEncoder.encode(AlarmController.shared.alarms)
        try alarmData.write(to: fileURL())
    } catch {
        print("Data was not able to save to persistent store: \(error.localizedDescription)")
    }
}

func loadFromPersistentStore() {
    let jsonDecoder = JSONDecoder()
    do {
        let dataToLoad = try Data(contentsOf: fileURL())
        let alarmsToLoad = try jsonDecoder.decode([Alarm].self, from: dataToLoad)
        self.alarms = alarmsToLoad
    } catch {
        print("there was an error loading from persistent store: \(error.localizedDescription)")
        }
    }
}

protocol AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

extension AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = alarm.name
        notificationContent.body = "You're alarm is going off!"
        notificationContent.badge = 1
        notificationContent.sound = UNNotificationSound.default
        
        let date = alarm.fireDate
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let notificationRequest = UNNotificationRequest(identifier: alarm.uuid, content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
        }
}

