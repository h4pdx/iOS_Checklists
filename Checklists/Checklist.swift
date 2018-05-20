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
    var iconName = "xx"
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    func countUncheckedItems() -> Int {
        /*
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
        */
        //print("Checklist::countUncheckedItems()")
        return items.reduce(0) {cnt, item in cnt + (item.checked ? 0 : 1)} // functional programming
    }

}
