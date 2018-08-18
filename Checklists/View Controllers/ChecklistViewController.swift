//
//  ViewController.swift
//  Checklists
//
//  Created by Ryan Hoover on 4/28/18.
//  Copyright © 2018 fatalerr. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    //var items = [ChecklistItem](); // array of checklist items
    var checklist: Checklist!
    var date: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // enable large titles
        // load items for documents folder
        navigationItem.largeTitleDisplayMode = .never
        title = checklist.name // pass necessary Checklist obj to VC when segue is performed
        //loadCheckListItems();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**********************************************************************************************************************
     ItemDetailVC protocol implementations
     */
    
    // implemented delegates for AddItemVC - cancel
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    // implemented delgates for AddItemVC Protocol - done + add to list
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        print("ChecklistVC::itemDetailVC(didFinishADDING)")

        let newRowIndex = checklist.items.count // get cell index
        checklist.items.append(item) // add new CheckListItem to array
        //checklist.sortChecklistItems()
        //tableView.reloadData()
        
        let indexPath = IndexPath(row: newRowIndex, section: 0) // no sections in the table view, all are sec 0
        let indexPaths = [indexPath] // needs to be an array to insert into tableview
        tableView.insertRows(at: indexPaths, with: .automatic) // update table with changes to data structure
        checklist.sortChecklistItems() // insert into table, then sort & reload
        tableView.reloadData()
        
        navigationController?.popViewController(animated: true)
        //saveChecklistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        print("ChecklistVC::itemDetailVC(didFinishEDITING)")
        if let index = checklist.items.index(of: item) { // uses equality property of NSObject to match objects (could probably overload == instead)
            let indexPath = IndexPath(row: index, section: 0) // match with index path from table view
            if let cell = tableView.cellForRow(at: indexPath) { // grab the valid cell at our IndexPath
                configureText(for: cell, with: item) // update text field with edited text
            }
        }
        checklist.sortChecklistItems()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
        //saveChecklistItems()
    }
    /**********************************************************************************************************************/

    // this method is called after the new view controller has been loaded, and BEFORE it appears on-screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // "AddItem" needs to be added to the segue identifier for this to work
        if (segue.identifier == "AddItem") { // specify the correct segue (could be more than one, depending on app)
            // new controller to be displayed is stored in segue.destination
            let controller = segue.destination as! ItemDetailViewController // downcast UIViewController obj to AddViewVC object
            controller.delegate = self // sets AddItemVC's delegate property to ChecklistVC
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            // find tthe table view row number by looking up the corresponding index path
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    /**********************************************************************************************************************
     Table View Delegates
     */

    // toggle checkmark
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // see if we have a valid cell at this row
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row] // initialize pointer to the ChecklistItem at this particular index
            item.toggleChecked() // toggle checkmark (checked/unchecked)
            configureCheckmark(for: cell, with: item) // update cell with toggled checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true) // update table
        //saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count // number of items currently in data structure
    }
    
    // make a table view cell using Prototype cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath) // updates
        let item = checklist.items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    // delete a row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row) // table view tells us what cell we are deleting
        // update cell (in this case delete it)
        let indexPaths = [indexPath] // tableView protocols require an Array object, even if its just one
        tableView.deleteRows(at: indexPaths, with: .automatic)
        //saveChecklistItems()
    }
    
    /**********************************************************************************************************************/
    
    // update table view label with data structure string
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        //label.text = item.text
        label.text = item.text
        
        if let label = cell.viewWithTag(1002) as? UILabel {
            date = item.dueDate
            let formatter = DateFormatter() // format Date object
            formatter.dateStyle = .medium // give the date a style
            formatter.timeStyle = .short //  give the time a seperate style
            let dueDate = formatter.string(from: date) // convert to string for label
            label.text = "Due: \(dueDate)"
        }
        cell.imageView!.image = UIImage(named: "✔︎")

        
    }
    
    // update checkmark icon based on underlying data
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        
        if let label = cell.viewWithTag(1001) as? UILabel {
        label.textColor = view.tintColor
        if (item.checked) {
            label.text = "✔︎"
        } else {
            label.text = ""
        }
        }
    }
    
}










