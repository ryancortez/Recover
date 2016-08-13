////
////  UserDefaultsManager.swift
////  Lists
////
////  Created by Ryan Cortez on 8/10/16.
////  Copyright © 2016 Ryan Cortez. All rights reserved.
////
//
//import Foundation
//
//class UserDefaultsManager: NSObject {
//    
//    class func saveListsToUserDefaults(lists: NSArray) {
//        let userDefaults = NSUserDefaults.standardUserDefaults()
//        let listData = NSKeyedArchiver.archivedDataWithRootObject(lists)
//        userDefaults.setObject(listData, forKey: "lists")
//        userDefaults.synchronize()
//    }
//    
//    class func fetchListsFromNSUserDefaults() -> Array<List>? {
//        let listsKey = "lists"
//        let userDefaults = NSUserDefaults.standardUserDefaults()
//        guard let listsData = userDefaults.objectForKey(listsKey) as? NSData else {
//            print("Did not recieve NSData from userDefaults using the key \(listsKey)")
//            return nil
//        }
//        guard let lists = NSKeyedUnarchiver.unarchiveObjectWithData(listsData) as? Array<List> else {
//            print("Did not recieve Array<List> from listsData")
//            return nil
//        }
//        return lists
//    }
//}
