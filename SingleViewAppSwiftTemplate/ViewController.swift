//
//  ViewController.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Treehouse on 12/8/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var currentGameView: SingleGameView? = nil
    var gameController: GameController? = nil

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        gameController = GameController(withDelegate: self)
        let game: SingleGame? = gameController?.gameFromStore()
        
        guard let newGame = game else {
            //Game controller unable to create a new game. So just return.
            return
        }
        
        currentGameView = SingleGameView(withSingleGame: newGame, singleGameViewDelegate: self)
        
        view.addSubview(currentGameView!)
        
        if #available(iOS 11.0, *) {
            currentGameView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            // Fallback on earlier versions
            currentGameView!.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        currentGameView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        currentGameView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        currentGameView!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(eventDirectionButtonTapped(_:)), name: NSNotification.Name(rawValue: "BoutTimeDirectionButtonTapped"), object: nil)
        
        
        //Once all the UI is setup, ask the game controller to begin the current game.
        gameController?.beginCurrentGame()
        
    }
}


extension ViewController: GameUpdateProtocol {
    
    func updateWithGameStatus(_ gameStatus: GameStatus) {
        currentGameView?.updateViewForGameStatus()
    }
    
    func updateWithGameAnswerStatus(_ answerStatus: GameAnswerStatus) {
        currentGameView?.updateViewForGameAnswerStatus()
    }
    
    func updateWithTimeRemaining(_ timeRemaining: Int) {
        let timeRemainingString: String = "0:\(timeRemaining)"
        currentGameView?.updateViewWithTimeRemainingString(timeRemainingString)
    }
    
    func swapEventViewPresentIn(_ positionOne: Int, _ positionTwo: Int) {
        currentGameView?.swapEventViewPresentIn(positionOne, positionTwo)
    }

}


extension ViewController: SingleGameViewProtocol {
    
    func loadNextGame() {
        
        let game: SingleGame? = gameController?.gameFromStore()
        if let game = game {
            //Game controller has successfully created a game with 4 events. Now instruct the game controller to begin.
            currentGameView?.updateWithGame(game)
            gameController?.beginCurrentGame()
        }
        else {
            //Maybe we have reached our game limit per round. So display the final score.
            let scoreVC: FinalScoreViewController = FinalScoreViewController(withUserScore: gameController!.numberOfCorrectAnswersInCurrentRound, numberOfGames: gameController!.numberOfGamesPerRound, playAgainCompletionHandler:  ( { [unowned self] () -> Void in
                
                self.gameController!.resetCurrentRoundData()
                self.loadNextGame()
            }))
            present(scoreVC, animated: true, completion: nil)
        }
        
    }
    
    
    func loadInformationFromWeb(_ urlString: String) {
        
        if urlString.isEmpty == false {
            let webViewController: EventInformationWebViewController = EventInformationWebViewController(withEventInformationURLString: urlString)
            present(webViewController, animated: true, completion: nil)
        }
        
    }

    
}


//Reordering.
extension ViewController {
    
    func eventDirectionButtonTapped(_ sender: Notification) {
        
        let direction: EventMovingDirection? = (sender.userInfo!["direction"]) as? EventMovingDirection
        let position: Int? = (sender.userInfo!["position"]) as? Int
        
        if let direction = direction, let position = position {
            
            //Tell the game controller to update the singleGame model with the new order of events.
            gameController?.moveEventPresent(inPosition: position, direction: direction)
        }
        
    }
}



//Shake to complete current game
extension ViewController {
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        guard let event = event else {
            return
        }
        if(event.subtype == UIEventSubtype.motionShake) {
            gameController?.finishCurrentGame()
        }
    }
    
}


