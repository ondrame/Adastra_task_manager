//
//  SettingsView.swift
//  Adastra_test
//
//  Created by Ondřej Měchura on 08.07.18.
//  Copyright © 2018 Ondřej Měchura. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications



class SettingsView: UIViewController, UITableViewDelegate, UITableViewDataSource, CreateCategoryDelegate {
    
    @IBOutlet weak var categoriesTableView: UITableView!
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var statusLabel: UILabel!
    
    
   var categories = [Category]() // categories array
   var tasks = [Task]() // tasks array
    
    let colorConvert = ColorConverter() // method for convert String to UIColor
    
    private var delegate:CategoryDelegate!
   var task_delegate:TaskDelegate!
    
    var del:CategoryDelegate!
    var task_del:TaskDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = del
        self.task_delegate = task_del
        
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
          categoriesTableView.tableFooterView = UIView()
        
        self.categories = loadCategories()
        self.tasks = loadTasks()
        
        self.notificationSwitch.isOn = notificationsEnabled()
        if notificationsEnabled(){
            self.statusLabel.text = "Disable notifications : "
        }else{
            self.statusLabel.text = "Enable notifications : "
        }
    } // end of viewDidLoad

    
    @IBAction func addCategory(_ sender: Any) {
        openCategoryEditor(adding: true, category:self.categories[1])
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        view.window?.layer.add(transition(direction: .right), forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return makeCategoryCell(id: "settingsCell", name: categories[indexPath.row].name, color: categories[indexPath.row].color, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions = [UITableViewRowAction]()
        
        if categories[indexPath.row].deletable{
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                if self.areTasks(category_id: self.categories[indexPath.row].id){
                    self.present(self.delete_category_alertView(category_id: self.categories[indexPath.row].id, indexPath: indexPath), animated: true, completion: nil)
                }else{
                   self.removeCategory(indexPath: indexPath)
                }
            }
           
            let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
                self.openCategoryEditor(adding: false, category: self.categories[indexPath.row])
            }
             actions.append(delete)
            actions.append(edit)
        }
        return actions
    }
    
    
 
    private func openCategoryEditor(adding:Bool, category:Category){
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc:CreateCategoryView = sb.instantiateViewController(withIdentifier: "CreateCategoryView") as! CreateCategoryView
        vc.del = self
        vc.adding = adding
        vc.category = category
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(vc, animated: true, completion: nil)
        self.view.alpha = 0.5
    }
    
    
    @IBAction func categorySwitchAction(_ sender: UISwitch) {
        
        if sender.isOn{
            self.statusLabel.text = "Disable notifications : "
            enableNotifications()
            saveSettings(status: true)
        }else{
            self.statusLabel.text = "Enable notifications : "
            disableNotifications()
            saveSettings(status: false)
        }
    }
    
    private func disableNotifications(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    
    
    // ------------CreatyCategoryDelegate methods------------------------
    func didCancel() {
        self.view.alpha = 1
    }
    
    func didConfirm() {
        self.view.alpha = 1
        self.categories.removeAll()
        self.categories = loadCategories()
        self.categoriesTableView.reloadData()
        delegate.categoriesChanged()
    }
    
    func didUpdate(id:String){
        deleteCategory(id: id)
    }
    // --------------------------------------------------------------
  
    
} // end of class
