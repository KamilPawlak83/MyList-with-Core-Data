//
//  ViewController.swift
//  MyList with Core Data
//
//  Created by Kamil Pawlak on 28/09/2021.
//

import UIKit

class ItemListViewController: UITableViewController {

    var itemList = ["Kamil", "Angelika"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    //MARK: - TableView Section
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListCell", for: indexPath)
        cell.textLabel?.text = itemList[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
 
    //MARK: - Add Button Pressed
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Add item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak ac] _ in
            guard let answer = ac?.textFields?[0].text else {return}
            self.itemList.append(answer)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
    
}

