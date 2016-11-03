//
//  NotificationService.swift
//  BubblegumNotificationsSwift
//
//  Created by Martin Berger on 8/29/16.
//  Copyright © 2016 Martin Berger. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class NotificationService: NSObject {
    
    var authorized: Bool = false
    let requestId = "Request ID"
    let categoryId = "Category ID"
    
    lazy private var category: UNNotificationCategory? = {
        let action = UNNotificationAction.init(identifier: "Action ID", title: "Action", options: [.foreground])
        let category = UNNotificationCategory.init(identifier: self.categoryId, actions: [action], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        return category
    }()
    
    func setupAtAppStart() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().setNotificationCategories([self.category!])
    }
    
    func requestAuthorization(callback: ((Bool) -> Void)?) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert]) { [unowned self] (granted, error) in
            self.authorized = granted
            if error != nil {
                print(error?.localizedDescription as String!)
            }
            
            NotificationCenter.default.post(name: .notificationServiceAuthorized, object: nil)
            
            if callback != nil {
                callback!(granted)
            }
        }
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent.init()
        content.title = "Notification"
        content.body = "Hello World"
        content.categoryIdentifier = self.categoryId
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 3.0, repeats: false)
        let request = UNNotificationRequest.init(identifier: self.requestId, content: content, trigger: trigger)

        schedule(request: request)
    }
    
    internal func schedule(request: UNNotificationRequest!) {
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            if error != nil {
                print(error?.localizedDescription as String!)
            }
        }
    }
    
    internal func check() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings: UNNotificationSettings) in
            self.authorized = (settings.authorizationStatus == .authorized)
        }
    }
}

extension NotificationService: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        completionHandler()
    }
}

class Notifications {
    static let service = NotificationService()
    static func setupAtAppStart() {
        self.service.setupAtAppStart()
    }
    static func schedule() {
        self.service.scheduleNotification()
    }
    static func authorize() {
        self.service.requestAuthorization(callback: nil)
    }
}

extension Notification.Name {
    static let notificationServiceAuthorized = Notification.Name("Authorized")
}
