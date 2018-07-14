//
//  DetailsView.swift
//  Adastra_test
//
//  Created by Ondřej Měchura on 10.07.18.
//  Copyright © 2018 Ondřej Měchura. All rights reserved.
//

import UIKit

class DetailsView: UIViewController, EditDelegate {
   
    var task:Task!
    var category:Category!
    
  var delegate:TaskDelegate!
   var del:TaskDelegate!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = task.name
        self.delegate = del
        self.navigationController?.navigationBar.barTintColor = category.color
        
        loadViews()
        addEditButton()
    } // end of viewDidLoad
    
    
    private func loadViews(){
        self.view.addSubview(getView(y: 0, height: 40, color: category.color, textColor: .white, content: "Category : ", category: false))
        self.view.addSubview(getView(y: 40, height: 40, color: .white, textColor: .black, content: category.name, category: true))
        self.view.addSubview(getView(y: 80, height: 40, color: category.color, textColor: .white, content: "Dead-line :", category: false))
        self.view.addSubview(getView(y: 120, height: 40, color: .white, textColor: .black, content: "\(task.day!)/\(task.month!)/\(task.year!)    \(task.hour!):\(task.minute!)", category: false))
        self.view.addSubview(getView(y: 160, height: 40, color: category.color, textColor: .white, content: "Notes : ", category: false))
        self.view.addSubview(noteView(y: 200, height: 40, content: task.note))
    }
    
    private func getView(y:CGFloat, height:CGFloat, color:UIColor, textColor:UIColor, content:String, category:Bool) -> UILabel{
        let view:UILabel = UILabel(frame: CGRect(x: 0, y: y, width: screenWidth(), height: height))
        view.backgroundColor = color
        view.textColor = textColor
        view.textAlignment = .center
        view.text = content
        
        if category{
            let categoryColorLabel = UILabel(frame: CGRect(x: view.frame.width - 30, y: 10, width: 20, height: 20))
            categoryColorLabel.backgroundColor = self.category.color
            categoryColorLabel.layer.cornerRadius = categoryColorLabel.frame.size.width / 2
            categoryColorLabel.clipsToBounds = true
            view.addSubview(categoryColorLabel)
        }
        return view
    }
    
    // add edit button to navigation bar
    private func addEditButton(){
        let edit:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(editNote))
        edit.tintColor = UIColor.white
        let delete:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
            delete.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItems = [edit,delete]
    }
    
    // sets and return view, where a note will be displayed
    private func noteView(y:CGFloat, height:CGFloat, content:String) -> UITextView{
        let noteView:UITextView = UITextView(frame: CGRect(x: 0, y: y, width: screenWidth(), height: height))
        noteView.text = content
        noteView.textAlignment = .center
        noteView.isUserInteractionEnabled = false
        return noteView
    }
    
 
    
   // EditDelegate method
    func taskEdited(task: Task, category: Category) {
        self.title = task.name
        self.navigationController?.navigationBar.barTintColor = category.color
        self.task = task
        self.category = category
        self.loadViews()
        delegate.taskChanged()
    }
    
    
    
   
} // end of class
