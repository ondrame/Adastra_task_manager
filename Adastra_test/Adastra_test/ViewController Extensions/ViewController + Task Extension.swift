//
//  ViewController + Task Extension.swift
//  Adastra_test
//
//  Created by Ondřej Měchura on 12.07.18.
//  Copyright © 2018 Ondřej Měchura. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

extension UIViewController{
    
    // update task informations
    func updateTask(task:Task, new_title:String,new_note:String, new_deadLine:Date, new_category_id:String, completed:Bool){
        let components = Calendar.current.dateComponents([.minute,.hour,.day,.month,.year], from: new_deadLine)
        deleteTask(task: task)
        addTask(category_id: new_category_id, task_id: task.task_id, title: new_title,note:new_note, deadLine: new_deadLine, completed: completed)
        registerNotification(components: components, id: task.task_id, title: new_title)
    }
    
    // update task completion status
    func updateTaskStatus(task:Task,completed:Bool, minute:String, hour:String, day:String, month:String, year:String){
        let format = DateFormatter()
        format.dateFormat = "dd.MM.yyyy'T'HH:mm"
        let date:Date = format.date(from: "\(day).\(month).\(year)T\(hour):\(minute)")!
        updateTask(task: task, new_title: task.name, new_note: task.note, new_deadLine: date, new_category_id: task.category_id, completed: completed)
    }
    
    
    // return an array with saved tasks
    func loadTasks() -> [Task]{
        var tasks = [Task]()
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Note")
        
        do{
            let results = try context.fetch(request)
            
            for s in results as! [NSManagedObject]{
                let category_id = s.value(forKey: "category_id") as! String
                let task_id = s.value(forKey: "task_id") as! String
                let task_title = s.value(forKey: "title") as! String
                let task_note = s.value(forKey: "note") as! String
                
                let minute = s.value(forKey: "minute") as! String
                let hour = s.value(forKey: "hour") as! String
                let day = s.value(forKey: "day") as! String
                let month = s.value(forKey: "month") as! String
                let year = s.value(forKey: "year") as! String
                
                let completed = s.value(forKey: "completed") as! Bool
                
                let task = Task(category_id: category_id, task_id: task_id, name: task_title, note: task_note, minute: minute, hour: hour, day: day, month: month, year: year, completed: completed)
                tasks.append(task)
            }
        }catch{
            print("Can not get tasks ")
        }
        return tasks
    }
    
    
    
    // save task to CoreData
    func addTask(category_id:String,task_id:String,title:String,note:String, deadLine:Date, completed:Bool){
        let components = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: deadLine)
        
        registerNotification(components: components, id: task_id, title: title) // Add new user notification
        
        var minute = "\(components.minute!)"
        let hour = "\(components.hour!)"
        let day = "\(components.day!)"
        let month = "\(components.month!)"
        let year = "\(components.year!)"
        
        if minute.count == 1{
            minute = "0\(minute)"
        }
        let appDel:AppDelegate = UIApplication.shared.delegate as!AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let task = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context)
        
        task.setValue(category_id, forKey: "category_id")
        task.setValue(task_id, forKey: "task_id")
        task.setValue(title, forKey: "title")
        task.setValue(note, forKey: "note")
        task.setValue(minute, forKey: "minute")
        task.setValue(hour, forKey: "hour")
        task.setValue(day, forKey: "day")
        task.setValue(month, forKey: "month")
        task.setValue(year, forKey: "year")
        task.setValue(completed, forKey: "completed")
        
        do{
            try context.save()
        }catch{
            print("Error with saving task")
        }
    }
    
    
    // register new notification to notificationCenter
    func registerNotification(components:DateComponents, id:String, title:String){
        let content = UNMutableNotificationContent()
        content.title = "It's time"
        content.body = "Deadline of " + title
        content.sound = UNNotificationSound.default()
     
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if (error != nil){
                print("Something went wrong")
            }
        }
    }
    
    
    // delete task from CoreData
    func deleteTask(task:Task){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.task_id]) // remove notification by task id
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        request.includesPropertyValues = false
        
        do{
            let items = try context.fetch(request)
            for s in items as! [NSManagedObject]{
                let k = s.value(forKey: "task_id") as! String
                
                if k == task.task_id{
                    context.delete(s as! NSManagedObject)
                }
            }
            try context.save()
        }catch{
            print("Error with deleting task")
        }
    }
   
} // end of class
