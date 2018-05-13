//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Swastik Soni on 13/05/2018.
//  Copyright © 2018 Swastik Soni. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

   
    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    // MARK: - Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
   
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        var categoryTextfield = UITextField()
        
        alert.addTextField { (textField) in
            
            textField.placeholder = "Add new category"
            categoryTextfield = textField
        }
        
        let action = UIAlertAction(title: "Done", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = categoryTextfield.text
            self.categoryArray.append(newCategory)
            
            self.saveData()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

    func saveData() {
        
        
        do {
            try context.save()
        }
        catch {
            print("error saving data, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData(request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        }
        catch {
            print("error loading categories, \(error)")
        }
        
        tableView.reloadData()
    }
    
}
