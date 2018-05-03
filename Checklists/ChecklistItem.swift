//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Ryan Hoover on 4/29/18.
//  Copyright © 2018 fatalerr. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {
    var text = ""
    var checked = false

    
    func toggleChecked() {
        checked = !checked // swaps either way
    }
    
}
