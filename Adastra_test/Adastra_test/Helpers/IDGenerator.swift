//
//  IDGenerator.swift
//  Adastra_test
//
//  Created by Ondřej Měchura on 14.07.18.
//  Copyright © 2018 Ondřej Měchura. All rights reserved.
//

import Foundation

class IDGenerator{
    
    func generateID() -> String{
        var id:String = ""
        for i in 0 ..< 10 {
            let num = Int(arc4random_uniform(100) + 1)
            id += "\(num)"
        }
        return id
    }
} // end of class
