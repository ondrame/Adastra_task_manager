//
//  ViewController + CATransition Extension.swift
//  Adastra_test
//
//  Created by Ondřej Měchura on 12.07.18.
//  Copyright © 2018 Ondřej Měchura. All rights reserved.
//

import UIKit


extension UIViewController{
    // enum of CATransition animation directions
    enum direction{
        case left
        case right
    }
    
     // makes and return CATransition animation
    func transition(direction:direction) -> CATransition{
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        switch direction {
        case .left:transition.subtype = kCATransitionFromLeft
        case .right:transition.subtype = kCATransitionFromRight
        }
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return transition
    }
} // end of extension
