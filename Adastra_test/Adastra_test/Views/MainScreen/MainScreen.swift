//
//  MainScreen.swift
//  Adastra_test
//
//  Created by Ondřej Měchura on 07.07.18.
//  Copyright © 2018 Ondřej Měchura. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import EmptyDataSet_Swift

class MainScreen: UIViewController, UITableViewDelegate,UITableViewDataSource,CategoryDelegate, TaskDelegate, EmptyDataSetDelegate, EmptyDataSetSource {
   
    private var isSearching:Bool = false
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var TableView: UITableView!
    
    var categories = [Category]()
    var tasks = [Task]()
    var searchTasks = [Task]()
    
    var colorConvert = ColorConverter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.TableView.delegate = self
        self.TableView.dataSource = self
        
        self.TableView.emptyDataSetSource = self
        self.TableView.emptyDataSetDelegate = self
        
          TableView.tableFooterView = UIView()
        
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.categories = loadCategories()
        
        self.tasks = loadTasks()
        
        self.TableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
              self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0196078431372549, green: 0.462745098039216, blue: 1.0, alpha: 1.0)
    }
    
    @IBAction func openSettings(_ sender: Any) {
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc:SettingsView = sb.instantiateViewController(withIdentifier: "SettingsView") as! SettingsView
        vc.del = self
        vc.task_del = self
        view.window?.layer.add(transition(direction: .left), forKey: kCATransition)
        present(vc, animated: false, completion: nil)
    }
    
    
    @IBAction func addTask(_ sender: Any) {
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc:AddView = sb.instantiateViewController(withIdentifier: "AddView") as! AddView
        vc.del = self
    
        view.window?.layer.add(transition(direction: .right), forKey: kCATransition)
        present(vc, animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
               return self.searchTasks.count
        }else{
              return self.tasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier:String = "MainScreenCell"
        
        let task:Task!
        if isSearching{task = searchTasks[indexPath.row]}else{task = tasks[indexPath.row]}
        
        let cell:MainScreenCell = TableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MainScreenCell
     
        let category = getCategoryById(identifier: task.category_id, categories: self.categories)
        
        cell.titleLabel.text = task.name
        cell.deadLineLabel.text = "\(task.day!)/\(task.month!)/\(task.year!)  \(task.hour!):\(task.minute!)"
        cell.categoryColorLabel.layer.cornerRadius = cell.categoryColorLabel.frame.size.width / 2
        cell.categoryColorLabel.clipsToBounds = true
        cell.categoryColorLabel.backgroundColor = category.color
        cell.categoryLabel.text = category.name
        
        if task.completed{
       cell.completedImageView.image = #imageLiteral(resourceName: "success_icon")
        }else{
           cell.completedImageView.image = nil
        }
        return cell
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        label.text = "You have no tasks yet"
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions = [UITableViewRowAction]()
        
        var completeOptionTitle:String = ""
        
        var task:Task!
        
        if isSearching{task = searchTasks[indexPath.row]}else{task = tasks[indexPath.row]}
        if task.completed{completeOptionTitle = "Uncomplete"}else{completeOptionTitle = "Complete"}
        
       let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.deleteTask(task: task)
        
        if self.isSearching{self.searchTasks.remove(at: indexPath.row)
            self.tasks.removeAll()
            self.tasks = self.loadTasks()
        }else{
            self.tasks.remove(at: indexPath.row)
        }
                UIView.animate(withDuration: 0.1, animations: {
                    self.TableView.deleteRows(at: [indexPath], with: .fade)
                }, completion: { (completed) in
                    self.TableView.reloadData()
                })
            }
        
        let complete = UITableViewRowAction(style: .normal, title: completeOptionTitle) { (action, indexPath) in
            
            let completed = task.completed
          
            if completed!{
               self.updateTaskStatus(task: task, completed: false, minute: task.minute, hour: task.hour, day: task.day, month: task.month, year: task.year)
            }else{
                self.updateTaskStatus(task: task, completed: true, minute: task.minute, hour: task.hour, day: task.day, month: task.month, year: task.year)
            }
           self.taskChanged()
          self.filterTasks()
        }
        complete.backgroundColor = UIColor.orange
            actions.append(delete)
            actions.append(complete)
        
        return actions
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc:DetailsView = sb.instantiateViewController(withIdentifier: "DetailsView") as! DetailsView
        
        var task:Task!
        if isSearching{
            task = searchTasks[indexPath.row]
        }else{
            task = tasks[indexPath.row]
        }
        vc.task = task
        vc.del = self
        vc.category = getCategoryById(identifier: task.category_id, categories: self.categories)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        
        if (self.searchTextField.text?.isEmpty)!{
            isSearching = false
            self.searchTasks.removeAll()
            self.TableView.reloadData()
        }else{
            isSearching = true
            filterTasks()
        }
    }
    
    func filterTasks(){
        self.searchTasks.removeAll()
        for i in 0 ..< self.tasks.count{
            if tasks[i].name.localizedCaseInsensitiveContains(self.searchTextField.text!){
                searchTasks.append(tasks[i])
            }
        }
       self.TableView.reloadData()
    }
    
    // TaskDelegate method
    func taskChanged() {
        tasks.removeAll()
        self.tasks = loadTasks()
        TableView.reloadData()
    }
    
    // CategoryDelegateMethod
    func categoriesChanged() {
        self.categories.removeAll()
        self.categories = loadCategories()
        TableView.reloadData()
    }
} // end of class

