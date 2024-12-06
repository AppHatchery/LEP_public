//
//  NotificationManager.swift
//  LEP
//
//  Created by Yago Arconada on 9/19/24.
//

import UserNotifications
import UIKit
import Pendo

class NotificationManager {

    static let shared = NotificationManager()

    // Request permission to show notifications
    func requestPermission() {
        let center = UNUserNotificationCenter.current()

        // Check if permission has been requested before
        if UserDefaults.standard.bool(forKey: "notificationPermissionRequested") {
            return // Exit if the permission has already been requested
        }

        // Request permission to show notifications
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in

            // Store that permission has been requested
            UserDefaults.standard.set(true, forKey: "notificationPermissionRequested")

            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
            // Track the event only the first time
            PendoManager.shared().track("NotificationRequest", properties: ["granted" : granted])

            if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
    }


    // Schedule a notification
    func scheduleNotification() {
        // Create the content for the notification
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Don't forget to complete your task!"
        content.sound = UNNotificationSound.default

        // Set the trigger for the notification (for example, 10 seconds from now)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

        // Create the request with a unique identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // Add the notification request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
    }
}
