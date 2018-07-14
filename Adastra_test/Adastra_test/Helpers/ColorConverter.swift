//
//  ColorConverter.swift
//  Adastra_test
//
//  Created by Ondřej Měchura on 08.07.18.
//  Copyright © 2018 Ondřej Měchura. All rights reserved.
//

import Foundation
import UIKit

// convert string to UIColor
class ColorConverter{
    
    func convertColor(text:String) -> UIColor{
        var color:UIColor!
        
        switch text {
        case "red": color = UIColor.red
        case "blue": color = UIColor.blue
        case "green": color = UIColor.green
        case "yellow": color = UIColor.yellow
        case "pink": color = UIColor.purple
        default:break
        }
        return color
    }
  
}

