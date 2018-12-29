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


protocol GameStatusUpdateProtocol: class {
    func updateViewForGameStatus(_ gameStatus: GameStatus)
    func updateViewForGameAnswerStatus(_ answerStatus: GameAnswerStatus)
    func updateViewWithTimeRemainingString(_ timeRemainingString: String)
    func swapEventViewPresentIn(_ positionOne: Int, _ positionTwo: Int)
}


protocol GameValidatorProtocol: class {
    func answerStatusOfUserSelectedOrder(_ userSelectedOrder: [EventDisplay]) -> GameAnswerStatus
}



class SingleGame {
    
    
    var events: [EventDisplay] = []  //User order.
    weak var userInterfaceUpdateDelegate: GameStatusUpdateProtocol? = nil
    weak var validityCheckerDelegate: GameValidatorProtocol? = nil
    var gameTimer: EventTimer? = nil
    
    var currentGameStatus: GameStatus = .unknown {
        didSet {
            //Once the game status changes, update UI.
            userInterfaceUpdateDelegate?.updateViewForGameStatus(currentGameStatus)
        }
    }
    var currentGameAnswerStatus: GameAnswerStatus = .unknown {
        didSet {
            //Once we determine the correctness of user selected order, update UI.
            userInterfaceUpdateDelegate?.updateViewForGameAnswerStatus(currentGameAnswerStatus)
        }
    }
    
    
    init(withEventsToArrange events: [EventDisplay]) {
        self.events = events
    }
    
    
    init(withEventsToArrange events: [EventDisplay], userInterfaceUpdateDelegate: GameStatusUpdateProtocol?) {
        
        self.events = events
        self.userInterfaceUpdateDelegate = userInterfaceUpdateDelegate
        
    }
    
    init(withEventsToArrange events: [EventDisplay], gameValidatorDelegate: GameValidatorProtocol?) {
        
        self.events = events
        validityCheckerDelegate = gameValidatorDelegate
        
    }
    
    init(withEventsToArrange events: [EventDisplay], gameValidatorDelegate: GameValidatorProtocol?, userInterfaceUpdateDelegate: GameStatusUpdateProtocol?) {
        
        self.events = events
        validityCheckerDelegate = gameValidatorDelegate
        self.userInterfaceUpdateDelegate = userInterfaceUpdateDelegate
        
    }
    
    
    func updateGameStatus(_ gameStatus: GameStatus) {
        
        currentGameStatus = gameStatus
        
        if currentGameStatus == .completed {
            //Game is finished either through user shaking the device OR time out.
            //So now let us check the answer status.
            let answerStatus: GameAnswerStatus? = validityCheckerDelegate?.answerStatusOfUserSelectedOrder(events)
            if let answerStatus = answerStatus {
                updateGameAnswerStatus(answerStatus)
            }
            //And invalidate the countdown timer.
        }
    }
    
    func updateGameAnswerStatus(_ gameAnswerStatus: GameAnswerStatus) {
        currentGameAnswerStatus = gameAnswerStatus
    }
    
    
    
    func begin() {
        
        //Change the current game status.
        updateGameStatus(.inProgress)
        
        //Initiate the timer.
        if let _ = gameTimer {
            //Timer already setup. Just update it with relevant values.
            gameTimer?.update(withInitialValue: 10, direction: .reverse, delegate: self)
        }
        else {
            gameTimer = EventTimer(withInitialValue: 10, direction: .reverse, delegate: self)
        }
        gameTimer?.initiateTimer()

    }
    
    
    func reorderEventsAt(firstPosition positionOne: Int, secondPosition positionTwo: Int) {
        
        self.events.swapAt(positionOne, positionTwo)
        
        //Update SingleGameView
        userInterfaceUpdateDelegate?.swapEventViewPresentIn(positionOne, positionTwo)
    }
    
}



extension SingleGame: TimerProtocol {
    
    func updateWithCurrentTimerValue(_ value: Int) {
        
        let timeLeft: String = "0:\(value)"
        userInterfaceUpdateDelegate?.updateViewWithTimeRemainingString(timeLeft)
        
        if value == 0 {
            //Time out.
            updateGameStatus(.completed)
        }
        
    }
}
