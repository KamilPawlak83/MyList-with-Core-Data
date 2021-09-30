//
//  ItemListController.swift
//  MyList with Core Data
//
//  Created by Kamil Pawlak on 28/09/2021.
//

import UIKit
import CoreData

class ItemListController: UITableViewController {

    var itemList = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }

    
    //MARK: - TableView Section
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListCell", for: indexPath)
        cell.textLabel?.text = itemList[indexPath.row].name
        
        // This is a Ternary Operation
        cell.accessoryType = itemList[indexPath.row].checkmark == true ? .checkmark : .none
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // We change the state to the opposite (.checkmark or .none)
        itemList[indexPath.row].checkmark = !itemList[indexPath.row].checkmark
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveItems()
    }
 
    //MARK: - Add Button Pressed
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Add item", message: nil, preferredStyle: .alert)
        
        ac.addTextField { (textField) in
            textField.placeholder = "Type something"
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak ac] _ in
            let newItem = Item(context: self.context)
            newItem.checkmark = false
            
            newItem.name = ac?.textFields?[0].text ?? "New Item"
            self.itemList.append(newItem)
            
            self.saveItems()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
    
    //MARK: - Save Items
    
    func saveItems() {
        
        do {
        try context.save()
        } catch {
            print("Saving error: \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    //MARK: - Load Items
    // Item.fetchRequest() is a default value in this case
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()) {
        
        do {
            itemList = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - SearchBar Section
extension ItemListController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
       loadItems(with: request)
        
    }
   // We back to main state before we search something
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}
