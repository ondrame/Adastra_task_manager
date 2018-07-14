//
//  EditView.swift
//  Adastra_test
//
//  Created by Ondřej Měchura on 12.07.18.
//  Copyright © 2018 Ondřej Měchura. All rights reserved.
//

import UIKit

class EditView: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    var task:Task!
    private var category:Category! // default selected category
    
    
    private var date:Date!
    
    private var categories = [Category]()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextfield: UITextView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    

    @IBOutlet weak var saveButtonOutlet: UIBarButtonItem!
    
    private var new_category:Category!
    private var new_title:String!
    private var new_note:String!
    private var new_deadLine:Date!
    
    private var delegate:EditDelegate!
    var del:EditDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noteTextfield.delegate = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.delegate = del
        
        self.categories = loadCategories()
        
        // set default values
        self.category = getCategoryById(identifier: task.category_id, categories: categories)
        
        
        self.new_title = task.name
        self.new_note = task.note
        self.titleTextField.text = new_title
        self.noteTextfield.text = new_note
        setDefaultCell(id: task.category_id)
        setDefaultDate(minute: task.minute, hour: task.hour, day: task.day, month: task.month, year: task.year)
        

        self.saveButtonOutlet.isEnabled = false // set default state of save button
    } // end of viewDidLoad

    
    //--------------------- tableView methods---------------------------------
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return makeCategoryCell(id: "EditCell", name: categories[indexPath.row].name, color: categories[indexPath.row].color, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        new_category = categories[indexPath.row]
        check()
    }
    //-------------------------------------------------------------------------
    
    @IBAction func backAction(_ sender: Any) {
        view.window?.layer.add(transition(direction: .left), forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    
    // set cell of category, which is saved in a task
    private func setDefaultCell(id:String){
        for i in 0 ..< categories.count{
            if categories[i].id == id{
               
                let indexPath:IndexPath = IndexPath(row: i, section: 0)
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)

                self.new_category = self.categories[indexPath.row]
            }
        }
    }
    
    // set DatePicker value to task dead-line
    private func setDefaultDate(minute:String, hour:String, day:String, month:String, year:String){
        let dateString = "\(day).\(month).\(year)T\(hour):\(minute)"
        let format = DateFormatter()
            format.dateFormat = "dd.MM.yyyy'T'HH:mm"
        let date:Date = format.date(from: dateString)!
        self.datePicker.setDate(date, animated: true)
        self.date = date
        self.new_deadLine = date
    }
    
    // check required conditions for task update
    private func check(){
        if self.category.id == self.new_category.id && self.date == self.new_deadLine && self.titleTextField.text == self.task.name && self.new_note == self.task.note {
     self.saveButtonOutlet.isEnabled = false
        }else{
          self.saveButtonOutlet.isEnabled = true
        }
    }
    
   
   // save updated task
    @IBAction func saveAction(_ sender: Any) {
          let components = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: new_deadLine)
        updateTask(task: self.task, new_title: self.new_title, new_note: self.new_note, new_deadLine: self.new_deadLine, new_category_id: self.new_category.id, completed: task.completed)
        task.name = new_title
        task.note = new_note
        task.minute = "\(components.minute!)"
        task.hour = "\(components.hour!)"
        task.day = "\(components.day!)"
        task.month = "\(components.month!)"
        task.year = "\(components.year!)"
        task.category_id = new_category.id
        
        if task.minute.count == 1{
            task.minute = "0\(task.minute)"
        }
        
        delegate.taskEdited(task: self.task, category: new_category)
        self.dismiss(animated: true, completion: nil)
    }
    
    // detects if DatePicker changed value
    @IBAction func dateChanged(_ sender: Any) {
        self.new_deadLine = datePicker.date
        check()
    }

    // detects when title changed
    @IBAction func titleChanged(_ sender: Any) {
        self.new_title = titleTextField.text
        check()
    }
    
    // detects when note textView changed
    func textViewDidChange(_ textView: UITextView) {
        self.new_note = textView.text
        check()
    }
  
    
} // end of class
