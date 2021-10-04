//
//  SwipeCellKitController.swift
//  MyList with Core Data
//
//  Created by Kamil Pawlak on 04/10/2021.
//

import UIKit
import SwipeCellKit

class SwipeCellKitController: UITableViewController, SwipeTableViewCellDelegate {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 65.0
    
    }
    
    // MARK: - TableView Section

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
    
    cell.delegate = self
    return cell
}
    
    
    
    
    
    
    
    
    //MARK: - SwipeCellKit Section
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            // handle action by updating model with deletion
            self.updateData(at: indexPath)
            
        }
        // Here is our "Trash" icon
        deleteAction.image = UIImage(named: "Trash")
        
        return [deleteAction]
        
    }

    
    
    func updateData (at indexPath: IndexPath) {
        //Update our data
    }
    
}
