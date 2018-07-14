//
//  Config_file.swift
//  Adastra_test
//
//  Created by Ondřej Měchura on 08.07.18.
//  Copyright © 2018 Ondřej Měchura. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import UserNotifications

extension AppDelegate{
    
    // this function is called only once, after a first app launch
    func config(){
        if categoryEmpty(){
            createCategory(name: "Work", color: "pink")
            createCategory(name: "Home", color: "blue")
            requestNotificationPermission()
            enableNotifications()
        }
    }
    
   // create and save new category
    func createCategory(name:String, color:String){
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let data = NSEntityDescription.insertNewObject(forEntityName: "Kind", into: context)
        data.setValue(generateID(), forKey: "id")
        data.setValue(name, forKey: "name")
        data.setValue(color, forKey: "color")
        data.setValue(false, forKey: "deletable")
        
        do{
            try context.save()
        }catch{
            print("Can not set new category")
        }
    }
    
    // enable user notifications for task
    private func enableNotifications(){
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let data = NSEntityDescription.insertNewObject(forEntityName: "Notifications", into: context)
        data.setValue(true, forKey: "enabled")
        do{
            try context.save()
        }catch{
            print("Saving default notifications status failed")
        }
    }
    
    
    
    // checks if some categories are already stored
    func categoryEmpty() -> Bool{
        var empty:Bool = false
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Kind")
        do{
            let results = try context.fetch(request)
            if results.count == 0{
             empty = true
            }
        }catch{
         print("Can not get categories from Core data")
        }
        return empty
    }
    
    
    // generate random category ID
   func generateID() -> String{
        var id:String = ""
        for i in 0 ..< 10 {
            let num = Int(arc4random_uniform(100) + 1)
            id += "\(num)"
        }
        return id
    }
    
    // request user permission for sending notifications
    func requestNotificationPermission(){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert,.sound]) { (granted, error) in
            if !granted{
                
            }
        }
    }

} // end of extension
