//
//  CategoryCell.swift
//  Adastra_test
//
//  Created by Ondřej Měchura on 13.07.18.
//  Copyright © 2018 Ondřej Měchura. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    func makeCategoryCell(id:String, name:String, color:UIColor, tableView:UITableView) -> UITableViewCell{
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: id)!

        let label:UILabel = UILabel(frame: CGRect(x: self.view.frame.width - 30, y: 10, width: 24, height: 24))
        label.backgroundColor = color
        label.layer.cornerRadius = label.frame.width / 2
        label.clipsToBounds = true
        
        cell.addSubview(label)
        
        cell.textLabel?.text = name
        cell.textLabel?.textAlignment = .center
        
        return cell
    }
}
