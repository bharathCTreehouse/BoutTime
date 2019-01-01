//
//  EventArrayAddition.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Bharath Chandrashekar on 31/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation


extension Array where Element == EventDisplay  {
    
    func isEqualToEventArray(_ list: [EventDisplay]) -> Bool {
        
        var isEqual: Bool = false
        
        for(index, data) in self.enumerated() {
            
            if data.year == list[index].year &&  data.eventTitle == list[index].eventTitle {
                isEqual = true
            }
            else {
                isEqual = false
                break
            }
            
        }
        
        return isEqual
    }
    
}
