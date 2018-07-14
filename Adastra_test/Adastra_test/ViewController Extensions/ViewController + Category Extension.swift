//
//  ViewController + Category Extension.swift
//  Adastra_test
//
//  Created by Ondřej Měchura on 12.07.18.
//  Copyright © 2018 Ondřej Měchura. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController{
    // returns an array of stored categories
    func loadCategories() -> [Category]{
        
        var categories = [Category]()
        
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Kind")
        let colorConvert = ColorConverter()
        do{
            let results = try context.fetch(request)
            for s in results as! [NSManagedObject]{
                
                let c = s.value(forKey: "color") as! String
                let name = s.value(forKey: "name") as! String
                let id = s.value(forKey: "id") as! String
                let deletable = s.value(forKey: "deletable") as! Bool
                
                let color = colorConvert.convertColor(text: c)
                let category = Category(color: color, name: name, id: id, deletable: deletable)
                categories.append(category)
            }
        }catch{
            print("Can not get categories")
        }
        return categories
    }
    
    // finds and returns category by ID
    func getCategoryById(identifier:String, categories:[Category]) -> Category{ // finds category by id and return it
        var category:Category!
        for i in categories{
            if i.id == identifier{
                category = i
                break
            }
        }
        return category
    }
} // end of extension
