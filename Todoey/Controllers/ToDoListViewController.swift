//
//  ViewController.swift
//  Todoey
//
//  Created by Zachary D Hoffman on 9/11/19.
//  Copyright © 2019 Modernity. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [String]{
//            itemArray = items
//        }
        
        loadItems()
        
        
        
        print(self.dataFilePath)
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error in loading items from \(error)")
            }
        }
    }
    
    
    func saveData(dataArray:[Item]){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(dataArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }

    }
    

    //MARK - Tableview Datasource Methods
    
    //Creates a number of cells equal to length of itemArray
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        
        
        
        
        return cell
    }
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //set done property to the opposite of its current value
        
        self.saveData(dataArray: self.itemArray)
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        

        
    }
    
    //MARK - Add New Items
    
    
    
    @IBAction func Add(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once user clicks add item button on UI Alert
            
            let newItem = Item()
            
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            self.tableView.reloadData()
            
            self.saveData(dataArray: self.itemArray)
            
            
            
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
            self.saveData(dataArray: self.itemArray)
        }
        
        return [deleteAction] //required format for this function
    }
    
}

