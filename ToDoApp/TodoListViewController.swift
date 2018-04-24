//
//  ViewController.swift
//  ToDoApp
//
//  Created by Swastik Soni on 22/04/2018.
//  Copyright © 2018 Swastik Soni. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Kiss Swastik", "Eat cheese", "Work out"]
    let savedItem = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        if let items = savedItem.array(forKey: "TodoItemList") as? [String] {
            itemArray = items
        } 
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemCell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        itemCell.textLabel?.text = itemArray[indexPath.row]
        
        return itemCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }

    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
            print("1")
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            
            print("2")
           tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
    
       let alert = UIAlertController(title: "Add new Todo item", message: "", preferredStyle: .alert)
        
        var item = UITextField()
        alert.addTextField { (textField) in
            textField.placeholder = "Create new item"
            item = textField
        }
        
        let action = UIAlertAction(title: "Add item", style: UIAlertActionStyle.default) { (action) in
            
           
                self.itemArray.append(item.text!)
            
            self.savedItem.set(self.itemArray, forKey: "TodoItemList")
            
                self.tableView.reloadData()
           
        }
        
         alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
}

