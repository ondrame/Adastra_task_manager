//
//  CreateCategory + Extension.swift
//  Adastra_test
//
//  Created by Ondřej Měchura on 10.07.18.
//  Copyright © 2018 Ondřej Měchura. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension CreateCategoryView{
    
    
    func addCategory(name:String, color:UIColor){
        let id = identifier_generator.generateID()
        var colorString:String = ""
        
        switch color {
        case UIColor.green:colorString = "green"
        case UIColor.blue:colorString = "blue"
        case UIColor.red:colorString = "red"
        case UIColor.yellow:colorString = "yellow"
        case UIColor.purple:colorString = "pink"
        default:break
        }
        
        
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let category = NSEntityDescription.insertNewObject(forEntityName: "Kind", into: context)
        category.setValue(id, forKey: "id")
        category.setValue(colorString, forKey: "color")
        category.setValue(name, forKey: "name")
        category.setValue(true, forKey: "deletable")
        
        do{
            try context.save()
        }catch{
            print("Saving category failed")
        }
    }
    
    
    func addCategoryByID(id:String, name:String, color:UIColor){
        var colorString:String = ""
        
        switch color{
        case UIColor.green: colorString = "green"
        case UIColor.blue:colorString = "blue"
        case UIColor.red:colorString = "red"
        case UIColor.yellow:colorString = "yellow"
        case UIColor.purple:colorString = "pink"
        default: break
        }
        
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let category = NSEntityDescription.insertNewObject(forEntityName: "Kind", into: context)
        category.setValue(id, forKey: "id")
        category.setValue(colorString, forKey: "color")
        category.setValue(name, forKey: "name")
        category.setValue(true, forKey: "deletable")
        
        do{
            try context.save()
        }catch{
            print("Saving category by ID failed")
        }
    }
    
    
} // end of class
