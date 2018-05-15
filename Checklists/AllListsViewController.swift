//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Ryan Hoover on 5/9/18.
//  Copyright © 2018 fatalerr. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {
    
    var lists = [Checklist]();
    //var lists = Array<Checklist>();

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true;
        
        var list = Checklist(name: "Birthdays");
        lists.append(list);
        
        list = Checklist(name: "Groceries");
        lists.append(list);
        
        list = Checklist(name: "Cool stuff");
        lists.append(list);
        
        list = Checklist(name: "To Do");
        lists.append(list);
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK:- Table data

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return 3;
        return lists.count;
    }

    // Fills in the cells with underlying data (Checklist objects in this case)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = makeCell(for: tableView);
        //cell.textLabel!.text = "List \(indexPath.row)";
        let checklist = lists[indexPath.row];
        cell.textLabel!.text = checklist.name;
        cell.accessoryType = .detailDisclosureButton;
        
        return cell;
    }
    
    // table view delegate envoked when you tap a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checklist = lists[indexPath.row];
        performSegue(withIdentifier: "ShowChecklist", sender: checklist);
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController // create new VC object for Add/Edit checklists and push it onto navigation stack
        
        controller.delegate = self // set 
        
        let checklist = lists[indexPath.row]
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
        let newRowIndex = lists.count
        lists.append(checklist)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        if let index = lists.index(of: checklist) { // find our checklist in thr array of lists
            let indexPath = IndexPath(row: index, section: 0) // find cell in table view matching index in array
            if let cell = tableView.cellForRow(at: indexPath) { // grab the cell if it isnt nil
                cell.textLabel!.text = checklist.name // update the name
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
