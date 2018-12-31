//
//  GameController.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Bharath Chandrashekar on 30/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation
import GameKit


protocol GameUpdateProtocol: class {
    
    func updateWithGameStatus(_ gameStatus: GameStatus)
    func updateWithGameAnswerStatus(_ answerStatus: GameAnswerStatus)
    func updateWithTimeRemaining(_ timeRemaining: Int)
    func swapEventViewPresentIn(_ positionOne: Int, _ positionTwo: Int)
}


class GameController {
    
    var currentGame: SingleGame? = nil
    weak var gameControllerDelegate: GameUpdateProtocol? = nil
    var gameTimer: EventTimer? = nil
    var numberOfGamesPerRound: Int = 6
    var gameCountInCurrentRound: Int = 0
    var numberOfEventsInEachGame: Int = 4
    var numberOfCorrectAnswersInCurrentRound:Int = 0
    var allEvents: [EventDisplay] = []
    
    
    init(withDelegate delegate: GameUpdateProtocol?) {
        
        gameControllerDelegate = delegate
        
        //Access events data from the plist and populate your data source.
        let rawListOfEvents: [[String: Any]]? = PlistConverter.arrayOfDictionariesFromPlist(withName: "Events")
        
        if let rawListOfEvents = rawListOfEvents {
            
            for eventDictionary in rawListOfEvents {
                let event: Event? = Event(withDictionary: eventDictionary)
                if let event = event {
                    allEvents.append(event)
                }
            }
        }
    }
    
    
    func gameFromStore() -> SingleGame? {
        
        //TODO: This method can actually throw an error to be more specific.
        
        if gameCountInCurrentRound < numberOfGamesPerRound && allEvents.isEmpty == false {
            
            let eventIndexes: [Int] = UniqueNumberGenerator.listOfUniqueIntegers(count: numberOfEventsInEachGame, upperLimit: allEvents.count-1)
            
            if eventIndexes.isEmpty == false {
                
                gameCountInCurrentRound = gameCountInCurrentRound + 1
                
                let firstEvent: EventDisplay = allEvents[eventIndexes.first!]
                let secondEvent: EventDisplay = allEvents[eventIndexes[1]]
                let thirdEvent: EventDisplay = allEvents[eventIndexes[2]]
                let fourthEvent: EventDisplay = allEvents[eventIndexes.last!]
                
                currentGame = SingleGame(withEventsToArrange: [firstEvent, secondEvent, thirdEvent, fourthEvent])
                return currentGame
            }
            
        }
        return nil
    }
    
    
   func beginCurrentGame() {
        
        if let game = currentGame {
            
            //Reset any existing timers if present.
            gameTimer?.invalidateTimer()
            gameTimer = nil
            
            //Change game status and initiate the timer.
            game.currentGameStatus = .inProgress
            gameControllerDelegate?.updateWithGameStatus(.inProgress)
            gameTimer = EventTimer(withInitialValue: 60, direction: .reverse, delegate: self)
            gameTimer?.initiateTimer()
        }
        
    }
    
    func finishCurrentGame() {
        
        //Time up.
        gameTimer?.invalidateTimer()
        gameTimer = nil
        
        //Update the current game status to completed and inform the delegate.
        currentGame?.currentGameStatus = .completed
        gameControllerDelegate?.updateWithGameStatus(.completed)
        
        //Now that the game is complete, check user selected order and validate.
        //Set it to correct for now.

        let gameControllerOrder: [EventDisplay] = currentGame!.events.sorted(by: { (eventOne: EventDisplay, eventTwo: EventDisplay) -> Bool in
            
            return eventOne.year < eventTwo.year
        })
        
        let userSelectedOrder: [EventDisplay] = currentGame!.events
        if  gameControllerOrder.isEventDisplayArray(userSelectedOrder) == true {
            numberOfCorrectAnswersInCurrentRound = numberOfCorrectAnswersInCurrentRound + 1
            currentGame?.currentGameAnswerStatus = .correct
            gameControllerDelegate?.updateWithGameAnswerStatus(.correct)
        }
        else {
            currentGame?.currentGameAnswerStatus = .incorrect
            gameControllerDelegate?.updateWithGameAnswerStatus(.incorrect)
        }
    }
    
    
    func moveEventPresent(inPosition position: Int, direction: EventMovingDirection) {
        
        if direction == .onlyUp {
            
            //Update the singleGame model with the updated order.
            currentGame?.reorderEventsAt(firstPosition: position - 1, secondPosition: position)
            
            //Inform the delegate about the swapped positions.
            gameControllerDelegate?.swapEventViewPresentIn(position - 1, position)
        }
        else if direction == .onlyDown {
            
            //Update the singleGame model with the updated order.
            currentGame?.reorderEventsAt(firstPosition: position, secondPosition: position + 1)
            
            //Inform the delegate about the swapped positions.
            gameControllerDelegate?.swapEventViewPresentIn(position, position + 1)
        }
        
    }
}



extension GameController: TimerProtocol {
    
    func updateWithCurrentTimerValue(_ value: Int) {
        
        //Inform the delegate about the updated time remaining.
        gameControllerDelegate?.updateWithTimeRemaining(value)
        
        if value == 0 {
            finishCurrentGame()
        }
    }
}



//Shake to complete current game
extension GameController {
    
}
