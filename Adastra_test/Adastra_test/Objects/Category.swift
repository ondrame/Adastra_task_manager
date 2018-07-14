//
//  Category.swift
//  Adastra_test
//
//  Created by Ondřej Měchura on 07.07.18.
//  Copyright © 2018 Ondřej Měchura. All rights reserved.
//

import Foundation
import UIKit


class Category:NSObject{
    
    
    var color:UIColor!
    var name:String!
    var id:String!
    var deletable:Bool!
    
    
    init(color:UIColor, name:String, id:String, deletable:Bool) {
        self.name = name
        self.id = id
        self.color = color
        self.deletable = deletable
    }
   
}
