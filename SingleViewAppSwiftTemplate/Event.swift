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
}

struct Event {
    let title: String
    let yearItOccurred: Int
}


extension Event: EventDisplay {
    
    var eventTitle : String {
        return title
    }
}




