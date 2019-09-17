//
//  ViewController.swift
//  Todoey
//
//  Created by Zachary D Hoffman on 9/11/19.
//  Copyright © 2019 Modernity. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    

    var itemArray = [String]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let items = defaults.array(forKey: "TodoListArray") as? [String]{
            itemArray = items
        }
    }
    
    
    

    //MARK - Tableview Datasource Methods
    
    //Creates a number of cells equal to length of itemArray
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Items
    
    
    @IBAction func Add(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once user clicks add item button on UI Alert
            self.itemArray.append(textField.text!)
            self.tableView.reloadData()
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            
            
        }
        
        alert.addTextField { (alerttextfield) in
            
            // Only adds the text field
            alerttextfield.placeholder = "Create New Item"
            textField = alerttextfield
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Allow users to swipe to delete rows
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "delete") { (action:UITableViewRowAction, indexPathRemove:IndexPath) in
            self.itemArray.remove(at: indexPathRemove.row)
            self.tableView.reloadData()
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
        }
        
        return [deleteAction] //required format for this function
    }
    
}

