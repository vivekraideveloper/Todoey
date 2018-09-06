//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Vivek Rai on 06/09/18.
//  Copyright © 2018 Vivek Rai. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var itemArray: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
        
        tableView.separatorStyle = .none
                
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = itemArray?[indexPath.row].name ?? "No Categories Added yet"
        
        guard let categoryColor = UIColor(hexString: (itemArray?[indexPath.row].colour)!) else{fatalError()}
        
        cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        
        cell.backgroundColor = UIColor(hexString: itemArray?[indexPath.row].colour ?? "FF7600")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = itemArray?[indexPath.row]
        }
    }
    
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        var textField =  UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Category()
            newItem.name = textField.text!
            newItem.colour = UIColor.randomFlat.hexValue()
            
            self.saveItems(category: newItem)
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func saveItems(category: Category) {
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print(error)
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        
       itemArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.itemArray?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print(error)
            }
        }
    }

    
    
}

















