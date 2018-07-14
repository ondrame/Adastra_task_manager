//
//  ViewController.swift
//  Adastra_test
//
//  Created by Ondřej Měchura on 07.07.18.
//  Copyright © 2018 Ondřej Měchura. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
      
  /*
        
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert,.sound]) { (granted, error) in
            if !granted{
                print("Something went wrong")
            }
        }
        
        
        let content = UNMutableNotificationContent()
        content.title = "test"
        content.body = "test is succesfull"
        content.sound = UNNotificationSound.default()
        
        
        var dateComponents = DateComponents()
        dateComponents.day = 7
        dateComponents.month = 7
        dateComponents.year = 2018
        dateComponents.hour = 21
        dateComponents.minute = 16
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: "test", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            print("Can not add notification to the center")
        }
        
        
        
        */
       
        
        
        
    } // end of viewDidLoad



}

