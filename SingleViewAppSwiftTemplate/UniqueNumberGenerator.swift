//
//  UniqueNumberGenerator.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Bharath Chandrashekar on 31/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation
import GameKit


class UniqueNumberGenerator {
    
    static func listOfUniqueIntegers(count: Int, upperLimit: Int) -> [Int] {
        
        var uniqueIntegers: [Int] = []
        
        while uniqueIntegers.count != count {
            
            let uniqueInteger: Int = randomInteger(withUpperLimit: upperLimit)
            if uniqueIntegers.contains(uniqueInteger) == false {
                uniqueIntegers.append(uniqueInteger)
            }
        }
        return uniqueIntegers
    }
}



extension UniqueNumberGenerator {
    
   static  func randomInteger(withUpperLimit limit: Int) -> Int {
        return GKRandomSource.sharedRandom().nextInt(upperBound: limit)
    }
}
