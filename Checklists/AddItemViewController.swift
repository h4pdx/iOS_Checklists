//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Ryan Hoover on 4/30/18.
//  Copyright © 2018 fatalerr. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // ensure the single input field does not turn grey when tapped - looks funny
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func done() {
        print("Contents of text field: \(textField.text!)")
        navigationController?.popViewController(animated: true)
    }
    
    // ensure keyboard comes up right away
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // steps in when view is first rendered
        textField.becomeFirstResponder() // giving the control focus to the text field
    }
    
    // UITextField deleagte method, invoked every time the user changes the text
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // first figure out what new text will be
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)! // convert from Obj-C NSRange object
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        /*
        if newText.isEmpty {
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
        }
        */
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    

}
