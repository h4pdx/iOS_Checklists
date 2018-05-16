//
//  Checklist.swift
//  Checklists
//
//  Created by Ryan Hoover on 5/14/18.
//  Copyright © 2018 fatalerr. All rights reserved.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var items = [ChecklistItem]() // each checklist contains a array of checklist items
    
    init(name: String) {
        self.name = name
        super.init()
    }
    

}
