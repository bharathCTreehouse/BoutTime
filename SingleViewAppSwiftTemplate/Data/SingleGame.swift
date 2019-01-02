//
//  SingleGame.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Bharath Chandrashekar on 28/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

enum GameStatus {
    
    case notStarted
    case inProgress
    case completed
    case unknown
}


enum GameAnswerStatus {
    
    case correct
    case incorrect
    case unknown
}


class SingleGame {
    
    var events: [EventDisplay] = []  //User selected order.
    var currentGameStatus: GameStatus = .unknown
    var currentGameAnswerStatus: GameAnswerStatus = .unknown
    
    
    init(withEventsToArrange events: [EventDisplay]) {
        self.events = events
    }
    
    func reorderEventsAt(firstPosition positionOne: Int, secondPosition positionTwo: Int) {
        self.events.swapAt(positionOne, positionTwo)
    }
    
    
    deinit {
        events.removeAll()
    }
    
}



