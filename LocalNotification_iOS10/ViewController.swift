//
//  ViewController.swift
//  LocalNotification_iOS10
//
//  Created by Martin Berger on 11/3/16.
//  Copyright © 2016 codecentric. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var scheduleButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotifications()
        
        self.scheduleButton?.isEnabled = false
        
        Notifications.authorize()
    }
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.onNotificationServiceAuthorized), name: .notificationServiceAuthorized, object: nil)
    }
    
    @objc fileprivate func onNotificationServiceAuthorized() {
        enableScheduleButton()
    }
    
    @IBAction func onScheduleNotification(sender: UIButton) {
        Notifications.schedule()
    }
    
    internal func enableScheduleButton() {
        self.scheduleButton?.isEnabled = true
    }
}

