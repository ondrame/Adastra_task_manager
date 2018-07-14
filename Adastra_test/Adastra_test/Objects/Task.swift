//
//  Task.swift
//  Adastra_test
//
//  Created by Ondřej Měchura on 07.07.18.
//  Copyright © 2018 Ondřej Měchura. All rights reserved.
//

import Foundation


class Task{
    
    var name:String!
    var note:String!
    var category_id:String!
    var task_id:String!
    
    var minute:String!
    var hour:String!
    var day:String!
    var month:String!
    var year:String!
    
    var completed:Bool!
    
    
    init(category_id:String,task_id:String,name:String,note:String, minute:String, hour:String, day:String, month:String, year:String, completed:Bool) {
        self.minute = minute
        self.hour = hour
        self.day = day
        self.month = month
        self.year = year
        
        self.name = name
        self.note = note
        self.category_id = category_id
        self.task_id = task_id
        self.completed = completed
    }
}
