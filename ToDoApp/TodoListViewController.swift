//
//  ViewController.swift
//  ToDoApp
//
//  Created by Swastik Soni on 22/04/2018.
//  Copyright © 2018 Swastik Soni. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadData()
        }
    }
    
   // let savedItem = UserDefaults.standard
//    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadData()//becaue load data takes a parameter with a default value its ok to not pass a parameter when calling
        
//        if let items = savedItem.array(forKey: "TodoItemList") as? [Item] {
//            itemArray = items
//        }
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
        saveData()
      
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
            
            let newItem = Item(context: self.context)
            newItem.title = item.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
           // self.savedItem.set(self.itemArray, forKey: "TodoItemList")
          self.saveData()
           
        }
        
         alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveData() {
        
        //let encoder = PropertyListEncoder()
        
        do{
            try context.save()
//            let data = try encoder.encode(itemArray)
//            try data.write(to: filePath!)
        }
        catch {
            
            print("error saving context, \(error)")
        }
        
     tableView.reloadData()
        
    }
    
    func loadData(request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {

        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES[cd] %@", (selectedCategory?.name)!)
        
        if let additionalPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else {
            
            request.predicate = categoryPredicate
        }
        
       // let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        }
        catch {
            print("error reading item, \(error)")
        }
        
        tableView.reloadData()
        
//        if let data = try? Data(contentsOf: filePath!) {
//
//            let decoder = PropertyListDecoder()
//
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            }
//            catch {
//                print("error decoding itemarray data, \(error)")
//            }
//        }
    }
}

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        loadData(request : request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
