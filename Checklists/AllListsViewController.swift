//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Ryan Hoover on 5/9/18.
//  Copyright © 2018 fatalerr. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    var dataModel: DataModel! // List of Checklists lives in this class
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Called whenever nav controller calls a new screen
    // Called BEFORE viewDidAppear() and sets value back to -1, therefore not triggering a segue every time
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        //print("AllListsVC::navigationController()")
        // Was back button tapped?
        if viewController === self { // determine if newly activated VC is this class
            // set the default to no value (-1)
            //UserDefaults.standard.set(-1, forKey: "ChecklistIndex") // if we are in ALLLists, no checklist is currently selected
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
    
    // UKit calls this his method after the VC has become visible, both on boot and whenver control switches back
    override func viewDidAppear(_ animated: Bool) {
        //print("AllListsVC::viewDidAppear()")
        super.viewDidAppear(animated)
        
        // waiting to register AllListsVC as Nav delegate HERE, instead of in navigationController(),
        // so that the -1 will not overrite the sotred userdefault value before the last viewed list has a chance to load
        navigationController?.delegate = self // make this VC the delegate for NavController
        
        // is really only performed once, on start up
        //let index = UserDefaults.standard.integer(forKey: "ChecklistIndex") // check to see if we have to perform segue
        let index = dataModel.indexOfSelectedChecklist // use getter
        if index != -1 { // if -1 then user was on main screen, we dont have to load any checklists
            let checklist = dataModel.lists[index] // load checklist object reference
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }
    

    // MARK:- Table data

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return 3;
        return dataModel.lists.count;
    }

    // Fills in the cells with underlying data (Checklist objects in this case)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = makeCell(for: tableView);
        //cell.textLabel!.text = "List \(indexPath.row)";
        let checklist = dataModel.lists[indexPath.row];
        cell.textLabel!.text = checklist.name;
        cell.accessoryType = .detailDisclosureButton;
        
        return cell;
    }
    
    // table view delegate envoked when you tap a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //UserDefaults.standard.set(indexPath.row, forKey: "ChecklistIndex") // set value of UserDefault checklist
        dataModel.indexOfSelectedChecklist = indexPath.row // use setter
        
        let checklist = dataModel.lists[indexPath.row];
        performSegue(withIdentifier: "ShowChecklist", sender: checklist);
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController // create new VC object for Add/Edit checklists and push it onto navigation stack
        
        controller.delegate = self // set 
        
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // create cell by hand (as opposed to using prototype cell)
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell";
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell;
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier);
        }
    }
    
    // prepare to load new screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController // pass ChecklistVC a checklist object from tapped row
            controller.checklist = sender as! Checklist
        } else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self // look for view controller and set delgate property to self
        }
    }
    
    // MARK:- List Detail Viw Controller Delgates
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        let newRowIndex = dataModel.lists.count
        dataModel.lists.append(checklist)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        if let index = dataModel.lists.index(of: checklist) { // find our checklist in the array of lists
            let indexPath = IndexPath(row: index, section: 0) // find cell in table view matching index in array
            if let cell = tableView.cellForRow(at: indexPath) { // grab the cell if it isnt nil
                cell.textLabel!.text = checklist.name // update the name
            }
        }
        navigationController?.popViewController(animated: true)
    }

}
