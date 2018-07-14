//
//  SettingsView + Extension.swift
//  Adastra_test
//
//  Created by Ondřej Měchura on 10.07.18.
//  Copyright © 2018 Ondřej Měchura. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension SettingsView{
    
    //  enable notifications
    func enableNotifications(){
        let tasks = loadTasks()
        
        for i in tasks{
            let format = DateFormatter()
            format.dateFormat = "dd.MM.yyyy'T'HH:mm"
            let date:Date = format.date(from: "\(i.day!).\(i.month!).\(i.year!)T\(i.hour!):\(i.minute!)")!
            let components = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: date)
            registerNotification(components: components, id: i.task_id, title: i.name)
        }
    }
    
    // checks if notification are enabled
    func notificationsEnabled() -> Bool{
        var enabled:Bool = false
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Notifications")
        do{
            let results = try context.fetch(request)
            for s in results as! [NSManagedObject]{
                let k = s.value(forKey: "enabled") as! Bool
              enabled = k
            }
        }catch{
            print("Can not get notifications status")
        }
        return enabled
    }
    
    // save setting to core data
    func saveSettings(status:Bool){
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notifications")
        request.includesPropertyValues = false
        
        do{
            let items = try context.fetch(request)
            
            for item in items{
                context.delete(item as! NSManagedObject)
            }
            try context.save()
        }catch{
            print("Deleting notification status failed")
        }
        
        let data = NSEntityDescription.insertNewObject(forEntityName: "Notifications", into: context)
        data.setValue(status, forKey: "enabled")
        do{
            try context.save()
        }catch{
            print("Status saving failed")
        }
    }
    
    // delete category from core data
    func deleteCategory(id:String){
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Kind")
        request.includesPropertyValues = false
        do{
            let items = try context.fetch(request)
            for s in items as! [NSManagedObject]{
                let k = s.value(forKey: "id") as! String
                if k == id{
                    context.delete(s as! NSManagedObject)
                }
            }
        }catch{
            print("Can not delete category from core data")
        }
    }
    
    // checks if they are any tasky with current category
    func areTasks(category_id:String) -> Bool{
        var tasks:Bool = false
        for i in self.tasks{
            if i.category_id == category_id{
                tasks = true
                break
            }
        }
        return tasks
    }
    
    // remove tasks with deleted category
    func removeTasks(category_id:String){
        for i in self.tasks{
            if i.category_id == category_id{
                deleteTask(task: i)
            }
        }
        task_delegate.taskChanged()
    }
    
    // show alertView with options for delete category (only if there are any tasks with this category)
     func delete_category_alertView(category_id:String, indexPath:IndexPath) -> UIAlertController{
        let alert = UIAlertController(title: "You have some tasks with this category", message: "With deleting this category you will also delete appended tasks", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.removeTasks(category_id: category_id)
            self.removeCategory(indexPath: indexPath)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        return alert
        
    }
    
    // remove category from categoriesTableView
    func removeCategory(indexPath:IndexPath){
        self.deleteCategory(id: self.categories[indexPath.row].id)
        self.categories.remove(at: indexPath.row)
        UIView.animate(withDuration: 0.1, animations: {
            self.categoriesTableView.deleteRows(at: [indexPath], with: .fade)
        }, completion: { (completed) in
            self.categoriesTableView.reloadData()
        })
    }
    
    
} // end of extension
