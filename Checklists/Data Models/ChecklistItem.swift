//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Ryan Hoover on 4/29/18.
//  Copyright © 2018 fatalerr. All rights reserved.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, Codable {
    var text = ""
    var checked = false
    
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    
    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    override init() {
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    deinit {
        removeNotification() // delete notification if item is deleted
    }

    func toggleChecked() {
        checked = !checked // swaps either way
    }
    
    func scheduleNotification() {
        removeNotification() // remove old notification if new one is being added
        if shouldRemind && dueDate > Date() {
            // Put item's text into the notification message
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default()
            
            // extract month, day, hour, minute from DueDate
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
            
            // Will show notification on the specified date
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            // convert item's numeric ID into a string and create a notification req object
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            
            // Add the new request to the notification center
            let center = UNUserNotificationCenter.current()
            center.add(request)
            print("Scheduled: \(request) for item ID: \(itemID)")
        }
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
        print("Notification removed.")
    }
    
}
