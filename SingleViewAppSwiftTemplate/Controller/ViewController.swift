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
        
        if gameController != nil {
            
            do {
                let game: SingleGame = try (gameController?.gameFromStore())!
                createAndSetupGameView(forGame: game)
                
                if currentGameView != nil {
                    
                    //Add observer to react to event movement action.
                    NotificationCenter.default.addObserver(self, selector: #selector(eventDirectionButtonTapped(_:)), name: NSNotification.Name(rawValue: "BoutTimeDirectionButtonTapped"), object: nil)
                    
                    //Once all the UI is setup, ask the game controller to begin the current game.
                    gameController?.beginCurrentGame()
                }
            }
            catch GameError.gameLimitReached {
                // We have reached our game limit per round. So display the final score.
                displayFinalScoreViewController()
                gameController?.finishCurrentRound()
                
            }
            catch GameError.eventCreationFailure {
                showAlert(forGameError: GameError.eventCreationFailure)
            }
            catch GameError.gameCreationFailure {
                showAlert(forGameError: GameError.gameCreationFailure)
            }
            catch {
                showAlert()
            }
        }
    }
    
    
    func createAndSetupGameView(forGame game: SingleGame) {
        
        currentGameView = SingleGameView(withSingleGame: game, singleGameViewDelegate: self)
        
        if currentGameView != nil {
            
            view.addSubview(currentGameView!)
            
            let safeAreaGuide: UILayoutGuide? = view.safeAreaLayoutGuideToBeUsed()
            
            if safeAreaGuide == nil {
                //Safe area guide not available.
                currentGameView!.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
                currentGameView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
                currentGameView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
                currentGameView!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            }
            else {
                //Safe area guide available.
                currentGameView!.topAnchor.constraint(equalTo: safeAreaGuide!.topAnchor).isActive = true
                currentGameView!.leadingAnchor.constraint(equalTo: safeAreaGuide!.leadingAnchor).isActive = true
                currentGameView!.trailingAnchor.constraint(equalTo: safeAreaGuide!.trailingAnchor).isActive = true
                currentGameView!.bottomAnchor.constraint(equalTo: safeAreaGuide!.bottomAnchor).isActive = true
            }
           
        }
        
    }
    
    
    deinit {
         currentGameView = nil
         gameController = nil
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
        
        do {
            let game: SingleGame = try gameController!.gameFromStore()
            
            //Game controller has successfully created a game with 4 events. Now instruct the game controller to begin.
            currentGameView?.updateWithGame(game)
            gameController?.beginCurrentGame()
            
        }
        catch GameError.gameLimitReached {
            // We have reached our game limit per round. So display the final score.
            displayFinalScoreViewController()
            gameController?.finishCurrentRound()
        }
        catch GameError.eventCreationFailure {
            showAlert(forGameError: GameError.eventCreationFailure)
        }
        catch GameError.gameCreationFailure {
            showAlert(forGameError: GameError.gameCreationFailure)
        }
        catch {
            showAlert()
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
    
    @objc func eventDirectionButtonTapped(_ sender: Notification) {
        
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
        if(event.subtype == UIEvent.EventSubtype.motionShake) {
            gameController?.finishCurrentGame()
        }
    }
    
}


//Showing final score view controller
extension ViewController {
    
    func displayFinalScoreViewController() {
        
        let scoreVC: FinalScoreViewController = FinalScoreViewController(withUserScore: gameController!.numberOfCorrectAnswersInCurrentRound, numberOfGames: gameController!.numberOfGamesPerRound, playAgainCompletionHandler:  ( { [unowned self] () -> Void in
            
            self.gameController!.resetCurrentRoundData()
            self.loadNextGame()
        }))
        present(scoreVC, animated: true, completion: nil)
        
    }
}


//Alert display
extension ViewController {
    
    func showAlert(forGameError error: GameError? = nil) {
        
        var errorMessage: String = "Unknown error has occurred."
        if error == .eventCreationFailure {
            errorMessage = "Unable to create events for the game."
        }
        else if error == .gameCreationFailure {
            errorMessage = "Failed to create a game with the necessary number of events."
        }
        
        let eventAlertController: UIAlertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        eventAlertController.addAction(okAction)
        
        present(eventAlertController, animated: true, completion: nil)
    }
    
}


