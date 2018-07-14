//
//  AddView.swift
//  Adastra_test
//
//  Created by Ondřej Měchura on 07.07.18.
//  Copyright © 2018 Ondřej Měchura. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class AddView: UIViewController, UITableViewDelegate, UITableViewDataSource{
  
    
    @IBOutlet weak var saveButtonOutlet: UIBarButtonItem!
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryTable: UITableView!
    @IBOutlet weak var noteTextfield: UITextView!
    
    
    private var delegate:TaskDelegate!
    var del:TaskDelegate!
    
    var dead_line:Date!
    var selected_category_id:String!
    
    var colorConvert = ColorConverter()
    let identifier_generator = IDGenerator()
    
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = del
        categoryTable.delegate = self
        categoryTable.dataSource = self
        categoryTable.tableFooterView = UIView()
        
        self.dead_line = self.datePicker.date
        self.datePicker.minimumDate = self.datePicker.date
        self.noteTextfield.text = ""
    
       self.categories = loadCategories()
        categoryTable.reloadData()
        
        self.saveButtonOutlet.isEnabled = false
    }
    
    // done action
    @IBAction func doneAction(_ sender: Any) {
       addTask(category_id: self.selected_category_id, task_id: identifier_generator.generateID(), title: self.nameTextfield.text!, note: noteTextfield.text, deadLine: self.dead_line, completed: false)
        delegate.taskChanged()
        cancel()
    }
    
    // cancel action
    @IBAction func cancelAction(_ sender: Any) {
      cancel()
    }
    
    // detect if datePicker changed value
    @IBAction func datePickerChanged(_ sender: Any) {
      self.dead_line = datePicker.date
    }
    
    // detect if nameTextView changed value
    @IBAction func nameTextViewChanged(_ sender: Any) {
        check()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return makeCategoryCell(id: "categoryCell", name: categories[indexPath.row].name, color: categories[indexPath.row].color, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selected_category_id = self.categories[indexPath.row].id
        check()
    }
    
   
    
    // cancel action body
    private func cancel(){
        view.window?.layer.add(transition(direction: .left), forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    

    // checks required conditions for add task
    private func check(){
        if self.selected_category_id != nil && self.nameTextfield.text?.isEmpty != true{
            self.saveButtonOutlet.isEnabled = true
        }else{
            self.saveButtonOutlet.isEnabled = false
        }
    }
    
    
    
   
    

} // end of class
