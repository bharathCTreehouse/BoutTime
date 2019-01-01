//
//  Event.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Bharath Chandrashekar on 27/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation


protocol EventDisplay {
    var eventTitle: String { get }
    var eventInformationWebLink: String? { get }
    var year: Int { get }
}

struct Event {
    let title: String
    let yearItOccurred: Int
    let informationLink: String?
}


extension Event: EventDisplay {
    
    var year: Int {
        return yearItOccurred
    }
    
    
    var eventTitle : String {
        return title
    }
    
    var eventInformationWebLink: String? {
        return informationLink
    }
}


extension Event {
    
    init?(withDictionary dictionary: [String: Any]) {
        
        guard let titleInDictionary = dictionary["title"] as? String, let year = dictionary["yearItOccurred"] as? Int else {
            
            //Without the title and the year, no point creating an event.
            return nil
        }
        title = titleInDictionary
        yearItOccurred = year
        informationLink = dictionary["informationLink"] as? String
    }
}




