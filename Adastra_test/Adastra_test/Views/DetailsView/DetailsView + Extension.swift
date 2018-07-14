//
//  DetailsView + Extension.swift
//  Adastra_test
//
//  Created by Ondřej Měchura on 14.07.18.
//  Copyright © 2018 Ondřej Měchura. All rights reserved.
//

import Foundation
import UIKit

extension DetailsView{
    func alertView() -> UIAlertController{
        let alertView:UIAlertController = UIAlertController(title: "Really ?", message: "This category will be deleted", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.deleteTask(task: self.task)
            self.delegate.taskChanged()
            self.navigationController?.popViewController(animated: true)
        }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        return alertView
    }
    
    // get screen width
    func screenWidth() -> CGFloat{
        return UIScreen.main.bounds.width
    }
    
    
    @objc func editNote(){
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc:EditView = sb.instantiateViewController(withIdentifier: "EditView") as! EditView
        vc.task = self.task
        vc.del = self
        
        view.window?.layer.add(transition(direction: .right), forKey: kCATransition)
        self.present(vc, animated: false, completion: nil)
    }
    
    @objc func deleteNote(){
        self.present(alertView(), animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
} // end of extension
