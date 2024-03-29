//
//  SingleGameView.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Bharath Chandrashekar on 27/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation
import UIKit

protocol SingleGameViewProtocol: AnyObject {
    func loadNextGame()
    func loadInformationFromWeb(_ urlString: String)
}


class SingleGameView: UIView {
    
    fileprivate var singleGame: SingleGame? = nil {
        didSet {
            createEventViews()
            setupEventView()
            setupTimerLabel()
            setupCorrectnessIndicatorView()
            setupInstructionLabel()
        }
    }
    fileprivate var instructionLabelTopConstraint: NSLayoutConstraint? = nil
    fileprivate var timerLabelTopConstraint: NSLayoutConstraint? = nil
    fileprivate var nextGameButtonTopConstraint: NSLayoutConstraint? = nil
    
    
    fileprivate var eventViews: [EventView] = []
    fileprivate var eventViewConstraints: [NSLayoutConstraint] = []
    
    fileprivate var timerLabel: UILabel? = nil
    fileprivate var nextGameButton: UIButton? = nil
    fileprivate var instructionLabel: UILabel? = nil
    weak fileprivate var delegate: SingleGameViewProtocol? = nil
    
    
    
    init(withSingleGame game: SingleGame, singleGameViewDelegate: SingleGameViewProtocol?) {
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        updateWithGame(game)
        delegate = singleGameViewDelegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func updateWithGame(_ game: SingleGame) {
        singleGame = game
    }
    
    
    func createEventViews() {
        
        if eventViews.isEmpty == true {
            
            //Event views have not been setup. Set them up.
            
            let allEvents: [EventDisplay] = singleGame!.events
            
            for (tracker, event) in allEvents.enumerated() {
                
                //Create event views and populate the array.
                
                var direction: EventMovingDirection = .upAndDown
                if tracker == 0 {
                    direction = .onlyDown
                }
                else if tracker == allEvents.count-1 {
                    direction = .onlyUp
                }
                let eventView: EventView = EventView(withEvent: event, positionInGame: tracker, eventMovingDirection: direction)
                addTapGestureRecognizerOn(eventView: eventView)
                eventViews.append(eventView)
            }
        }
        else {
            //Views have already been setup. Just update the content.
            for (tracker, eventView) in eventViews.enumerated() {
                let event: EventDisplay? = singleGame?.events[tracker]
                if let event = event {
                    eventView.updateEvent(event)
                    eventView.enableDirectionButtons(true)
                }
            }
        }
    }
    
    
    deinit {
        
        singleGame = nil
        instructionLabelTopConstraint = nil
        timerLabelTopConstraint = nil
        nextGameButtonTopConstraint = nil
        eventViews.removeAll()
        eventViewConstraints.removeAll()
        timerLabel = nil
        nextGameButton = nil
        instructionLabel = nil
        delegate = nil
    }
}


extension SingleGameView {
    
    func setupEventView() {
        
        if eventViewConstraints.isEmpty == true {
            
            //Event view constraints have not been setup. Set them up and store the top constraint of every event view in an array. This will be used to move the view up and down.
            
            for (tracker, eventView) in eventViews.enumerated() {
                
                var topConstraint: NSLayoutConstraint? = nil
                
                addSubview(eventView)
                
                if tracker == 0 {
                    
                    //First event view
                    topConstraint = eventView.topAnchor.constraint(equalTo: topAnchor, constant: 18.0)
                    topConstraint!.isActive = true
                    eventViewConstraints.append(topConstraint!)
                }
                else {
                    let previousViewBottomAnchor: NSLayoutAnchor = eventViews[tracker - 1].bottomAnchor
                    topConstraint = eventView.topAnchor.constraint(equalTo: previousViewBottomAnchor, constant: 9.0)
                    topConstraint!.isActive = true
                    eventViewConstraints.append(topConstraint!)
                }
                
                eventView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0).isActive = true
                eventView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0).isActive = true
                eventView.heightAnchor.constraint(equalToConstant: eventView.currentHeightOfView()).isActive = true
            }
        }
    }
    
    
    func setupTimerLabel() {
        
        if timerLabel == nil  {
            
            timerLabel = UILabel()
            timerLabel!.numberOfLines = 0
            timerLabel!.translatesAutoresizingMaskIntoConstraints = false
            timerLabel!.textColor = UIColor.white
            timerLabel!.font = UIFont.systemFont(ofSize: 40.0, weight: UIFont.Weight.regular)
            addSubview(timerLabel!)
            timerLabel!.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            let eventView: EventView? = eventViews.last
            timerLabelTopConstraint = timerLabel!.topAnchor.constraint(equalTo: eventView!.bottomAnchor, constant: 20.0)
            timerLabelTopConstraint!.isActive = true
            
        }
    }
    
    func setupCorrectnessIndicatorView() {
        
        if nextGameButton == nil {
            
            nextGameButton = UIButton(type: .system)
            nextGameButton!.translatesAutoresizingMaskIntoConstraints = false
            addSubview(nextGameButton!)
            nextGameButton!.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            let eventView: EventView? = eventViews.last
            nextGameButtonTopConstraint = nextGameButton!.topAnchor.constraint(equalTo: eventView!.bottomAnchor, constant: 19.0)
            nextGameButtonTopConstraint!.isActive = true
            nextGameButton?.addTarget(self, action: #selector(nextGameTapped(_:)), for: .touchUpInside)
        }
    }
    
    
    @objc func nextGameTapped(_ sender: UIButton) {
        delegate?.loadNextGame()
    }
    
    func setupInstructionLabel() {
        
        if instructionLabel == nil {
            
            instructionLabel = UILabel()
            instructionLabel!.numberOfLines = 0
            instructionLabel!.translatesAutoresizingMaskIntoConstraints = false
            instructionLabel!.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.regular)
            instructionLabel!.textColor = UIColor(red: 0.0, green: 111.0/255.0, blue: 148.0/255.0, alpha: 1.0)
            addSubview(instructionLabel!)
            instructionLabelTopConstraint = instructionLabel!.topAnchor.constraint(equalTo: timerLabel!.bottomAnchor, constant: 9.0)
            instructionLabelTopConstraint!.isActive = true
            instructionLabel!.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
    }
    
    
    func hideGameInformationView(_ shouldHide: Bool) {
        
        timerLabel?.isHidden = shouldHide
        nextGameButton?.isHidden = shouldHide
        instructionLabel?.isHidden = shouldHide
        
    }
}


extension SingleGameView {
    
    func updateViewForGameStatus() {
        
        if let gameStatus = singleGame?.currentGameStatus {
            
            if gameStatus == .inProgress {
                
                nextGameButton?.isHidden = true
                timerLabel!.isHidden = false
                instructionLabel!.isHidden = false
                instructionLabelTopConstraint!.isActive = false
                instructionLabelTopConstraint = instructionLabel!.topAnchor.constraint(equalTo: timerLabel!.bottomAnchor, constant: 9.0)
                instructionLabelTopConstraint!.isActive = true
                instructionLabel!.text = "Shake to complete"
            }
            else if gameStatus == .completed {
                //Disable event view buttons so that the user can't reorder once the game is over.
                for eventView in eventViews {
                    eventView.enableDirectionButtons(false)
                }
            }
            else {
                hideGameInformationView(true)
            }
        }
    }
    
    
    func updateViewForGameAnswerStatus() {
        
        if let answerStatus = singleGame?.currentGameAnswerStatus {
            
            timerLabel!.isHidden = true
            nextGameButton!.isHidden = false
            
            let eventView: EventView? = eventViews.last
            nextGameButtonTopConstraint!.isActive = false
            nextGameButtonTopConstraint = nextGameButton!.topAnchor.constraint(equalTo: eventView!.bottomAnchor, constant: 19.0)
            nextGameButtonTopConstraint!.isActive = true
            
            var correctnessImage: UIImage? = nil
            if answerStatus == .correct {
                correctnessImage = UIImage(named: "ImageCorrect")
            }
            else if answerStatus == .incorrect {
                correctnessImage = UIImage(named: "ImageIncorrect")
            }
            nextGameButton?.setBackgroundImage(correctnessImage, for: .normal)
            nextGameButton!.sizeToFit()
            
            instructionLabel!.isHidden = false
            instructionLabelTopConstraint!.isActive = false
            instructionLabelTopConstraint = instructionLabel!.topAnchor.constraint(equalTo: nextGameButton!.bottomAnchor, constant: 13.0)
            instructionLabelTopConstraint!.isActive = true
            instructionLabel!.text = "Tap events to learn more"
        }
        
    }
    
    
    func updateViewWithTimeRemainingString(_ timeRemainingString: String) {
        timerLabel?.text = timeRemainingString
    }
    
    
    func swapEventViewPresentIn(_ positionOne: Int, _ positionTwo: Int) {
        
        self.eventViews.swapAt(positionOne, positionTwo)
        self.eventViewConstraints.swapAt(positionOne, positionTwo)
        var isLastEventViewUpdated: Bool = false
        
        if (positionOne - 1) >= 0 {
            
            let eventViewForReference: EventView = self.eventViews[positionOne - 1]
            let eventViewToMove: EventView = self.eventViews[positionOne]
            eventViewToMove.eventPosition = positionOne
            
            modifyEventView(eventViewToMove, presentInPosition: positionOne, withEventViewReference: eventViewForReference)
            
            if positionOne == self.eventViews.count - 1 {
                //Last event view
                eventViewToMove.updateMovingDirection(.onlyUp)
                isLastEventViewUpdated = true
            }
            else {
                eventViewToMove.updateMovingDirection(.upAndDown)
            }
            
        }
        else {
            //First event
            let eventViewToMove: EventView = self.eventViews[positionOne]
            eventViewToMove.eventPosition = positionOne
            
            modifyEventView(eventViewToMove, presentInPosition: positionOne, withEventViewReference: nil)
            eventViewToMove.updateMovingDirection(.onlyDown)
            
        }
        
        
        if (positionTwo - 1) >= 0 {
            
            let eventViewForReference: EventView = self.eventViews[positionTwo - 1]
            let eventViewToMove: EventView = self.eventViews[positionTwo]
            eventViewToMove.eventPosition = positionTwo
            
            modifyEventView(eventViewToMove, presentInPosition: positionTwo, withEventViewReference: eventViewForReference)
            
            if positionTwo == self.eventViews.count - 1 {
                //Last event view
                eventViewToMove.updateMovingDirection(.onlyUp)
                isLastEventViewUpdated = true
                
            }
            else {
                eventViewToMove.updateMovingDirection(.upAndDown)
            }
        }
        else {
            //first event
            let eventViewToMove: EventView = self.eventViews[positionTwo]
            eventViewToMove.eventPosition = positionTwo
            
            modifyEventView(eventViewToMove, presentInPosition: positionTwo, withEventViewReference: nil)
            eventViewToMove.updateMovingDirection(.onlyDown)
            
        }
        
        //We might have to modify top constraint of one view below.
        var positionToModify: Int = positionTwo
        if positionOne > positionTwo {
            positionToModify = positionOne
        }
        positionToModify = positionToModify + 1
        
        if positionToModify < self.eventViews.count {
            
            let eventViewForReference: EventView = self.eventViews[positionToModify - 1]
            let eventViewToMove: EventView = self.eventViews[positionToModify]
            
            modifyEventView(eventViewToMove, presentInPosition: positionToModify, withEventViewReference: eventViewForReference)
        }
        
        
        if isLastEventViewUpdated == true {
            
            //Update timer label constraint.
            timerLabelTopConstraint?.isActive = false
            let eventView: EventView? = eventViews.last
            timerLabelTopConstraint = timerLabel!.topAnchor.constraint(equalTo: eventView!.bottomAnchor, constant: 20.0)
            timerLabelTopConstraint!.isActive = true
        }
        
        
        UIView.animate(withDuration: 0.5, animations: { [unowned self]() -> Void in
            self.layoutIfNeeded()
        })
    }
    
    
    
    func modifyEventView(_ eventViewToMove: EventView, presentInPosition position: Int, withEventViewReference eventViewForReference: EventView?) {
        
        var constraintToModify: NSLayoutConstraint = eventViewConstraints[position]
        constraintToModify.isActive = false
        
        if let eventViewForReference = eventViewForReference {
            constraintToModify = eventViewToMove.topAnchor.constraint(equalTo: eventViewForReference.bottomAnchor, constant: 9.0)
        }
        else {
            constraintToModify = eventViewToMove.topAnchor.constraint(equalTo: topAnchor, constant: 18.0)
        }
        constraintToModify.isActive = true
        
        self.eventViewConstraints.remove(at: position)
        self.eventViewConstraints.insert(constraintToModify, at: position)
    }
    
}



extension SingleGameView {
    
    func addTapGestureRecognizerOn(eventView: EventView) {
        
        let event: EventDisplay? = eventView.event
        
        if let event = event, let _ = event.eventInformationWebLink {
            let eventInfoGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showEventInformation(_:)))
            eventView.addGestureRecognizer(eventInfoGestureRecognizer)
        }
        
    }
    
    
    @objc func showEventInformation(_ sender: UITapGestureRecognizer) {
        
        if singleGame?.currentGameStatus == .completed {
            
            //Show the web view only when a game is complete.
            
            let eventView: EventView? = sender.view as? EventView
            if let eventView = eventView, let link = eventView.event?.eventInformationWebLink {
                delegate?.loadInformationFromWeb(link)
            }
        }
    }
    
}
