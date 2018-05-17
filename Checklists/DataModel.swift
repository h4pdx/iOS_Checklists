//
//  DataModel.swift
//  Checklists
//
//  Created by Ryan Hoover on 5/15/18.
//  Copyright © 2018 fatalerr. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
    }
    
    
    // file:// URL
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklists() {
        //print("DataModel::saveCheckLists()")
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array.")
        }
    }
    
    func loadChecklists() {
        //print("DataModel::loadCheckLists()")
        let path = dataFilePath() // get results of file path
        // try? returns nil if no object - alternative to do-catch blocks
        if let data = try? Data(contentsOf: path) { // try to load contents of Checklists.plists
            let decoder = PropertyListDecoder() // create decoder instance
            do {
                lists = try decoder.decode([Checklist].self, from: data) // load array of Checklists into lists array
            } catch {
                print("Error decoding item array.")
            }
        }
    }
    
    func registerDefaults() {
        let dictionary = ["ChecklistIndex": -1]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
}
