//
//  ViewController.swift
//  ToDoApp
//
//  Created by Swastik Soni on 22/04/2018.
//  Copyright © 2018 Swastik Soni. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
var itemArray = [Item]()
    let savedItem = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let newItem = Item()
        newItem.title = "someItem"
   
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "someOtherItem"
        itemArray.append(newItem2)
        
        if let items = savedItem.array(forKey: "TodoItemList") as? [Item] {
            itemArray = items
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemCell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        itemCell.textLabel?.text = itemArray[indexPath.row].title
        
        //value = condition ? valueiftrue : valueiffalse
        itemCell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return itemCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(itemArray.count)
        return itemArray.count
    }

    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
      
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
            
           let newItem = Item()
            newItem.title = item.text!
            self.itemArray.append(newItem)
            
            self.savedItem.set(self.itemArray, forKey: "TodoItemList")
            
                self.tableView.reloadData()
           
        }
        
         alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
}

