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
            UserDefaults.standard.synchronize()
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
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
                sortChecklists()
            } catch {
                print("Error decoding item array.")
            }
        }
    }
    
    // set up defaults at boot
    func registerDefaults() {
        let dictionary: [String:Any] = ["ChecklistIndex": -1, "FirstTime": true]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    // First time after fresh install; create a new list and segue to it
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        // is this the first time launching app?
        if firstTime || lists.count == 0 {
            let checklist = Checklist(name: "New List") // create new checklist for the first time
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0 // index for segue
            userDefaults.set(false, forKey: "FirstTime") // no longer first time
            userDefaults.synchronize() // sync
        }
    }
    
    func sortChecklists() {
        lists.sort(by: {checklist1, checklist2 in return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending})
    }
    
}
