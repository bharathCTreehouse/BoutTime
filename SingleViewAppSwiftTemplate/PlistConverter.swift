//
//  PlistConverter.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Bharath Chandrashekar on 31/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation


class PlistConverter {
    
    static func dictionaryFromPlist(withName nameOfPlist: String) -> [String: Any]? {
        
        if let path = pathOfPlistWithName(nameOfPlist) {
            
            let dictionary: NSDictionary? = NSDictionary(contentsOfFile: path)
            if let dictionary = dictionary as? [String: Any] {
                return dictionary
            }
            
        }
        return nil
    }
    
    
    static func arrayOfDictionariesFromPlist(withName nameOfPlist: String) -> [[String: Any]]? {
        
       if let path = pathOfPlistWithName(nameOfPlist) {
            
            let array: NSArray? = NSArray(contentsOfFile: path)
            if let array = array as? [[String: Any]] {
                return array
            }
            
        }
        return nil
    }
    
}



extension PlistConverter {
    
    static func pathOfPlistWithName(_ name: String) -> String? {
        return Bundle.main.path(forResource: name, ofType: "plist")
        
    }
    
}
