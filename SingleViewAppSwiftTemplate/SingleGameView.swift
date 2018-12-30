//
//  SingleGameView.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Bharath Chandrashekar on 27/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation
import UIKit

class SingleGameView: UIView {
    
    var singleGame: SingleGame? = nil {
        didSet {
            createEventViews()
            setupEventView()
            setupTimerLabel()
            setupCorrectnessIndicatorView()
            setupInstructionLabel()
        }
    }
    var instructionLabelTopConstraint: NSLayoutConstraint? = nil
    var timerLabelTopConstraint: NSLayoutConstraint? = nil
    var correctnessIndicatorImageViewTopConstraint: NSLayoutConstraint? = nil


    var eventViews: [EventView] = []
    var eventViewConstraints: [NSLayoutConstraint] = []
    
    var timerLabel: UILabel? = nil
    var correctnessIndicatorView: UIImageView? = nil
    var instructionLabel: UILabel? = nil


    
    init(withSingleGame game: SingleGame) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        updateWithGame(game)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func updateWithGame(_ game: SingleGame) {
        singleGame = game
    }
    
    
    func createEventViews() {
        
        eventViews.removeAll()
        
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
            eventViews.append(eventView)
        }
    }
}


extension SingleGameView {
    
    func setupEventView() {
        
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
    
    
    func setupTimerLabel() {
        
        if timerLabel == nil  {
            
            timerLabel = UILabel()
            timerLabel!.numberOfLines = 0
            timerLabel!.translatesAutoresizingMaskIntoConstraints = false
            timerLabel!.textColor = UIColor.white
            timerLabel!.font = UIFont.systemFont(ofSize: 40.0, weight: UIFontWeightRegular)
            addSubview(timerLabel!)
            timerLabel!.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            let eventView: EventView? = eventViews.last
            timerLabelTopConstraint = timerLabel!.topAnchor.constraint(equalTo: eventView!.bottomAnchor, constant: 20.0)
            timerLabelTopConstraint!.isActive = true
            
        }
        
    }
    
    func setupCorrectnessIndicatorView() {
        
        if correctnessIndicatorView == nil {
            
            correctnessIndicatorView = UIImageView(image: nil)
            correctnessIndicatorView!.translatesAutoresizingMaskIntoConstraints = false
            addSubview(correctnessIndicatorView!)
            correctnessIndicatorView!.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            let eventView: EventView? = eventViews.last
            correctnessIndicatorImageViewTopConstraint = correctnessIndicatorView!.topAnchor.constraint(equalTo: eventView!.bottomAnchor, constant: 19.0)
            correctnessIndicatorImageViewTopConstraint!.isActive = true
            correctnessIndicatorView?.isHidden = true
            
        }
        
    }
    
    func setupInstructionLabel() {
        
        if instructionLabel == nil {
            
            instructionLabel = UILabel()
            instructionLabel!.numberOfLines = 0
            instructionLabel!.translatesAutoresizingMaskIntoConstraints = false
            instructionLabel!.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightRegular)
            instructionLabel!.textColor = UIColor(red: 0.0, green: 111.0/255.0, blue: 148.0/255.0, alpha: 1.0)
            addSubview(instructionLabel!)
            instructionLabelTopConstraint = instructionLabel!.topAnchor.constraint(equalTo: timerLabel!.bottomAnchor, constant: 9.0)
            instructionLabelTopConstraint!.isActive = true
            instructionLabel!.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
    }
    
    
    func hideGameInformationView(_ shouldHide: Bool) {
        
        timerLabel?.isHidden = shouldHide
        correctnessIndicatorView?.isHidden = shouldHide
        instructionLabel?.isHidden = shouldHide
        
    }
}


extension SingleGameView {
    
    func updateViewForGameStatus() {
        
        if let gameStatus = singleGame?.currentGameStatus {
            
            if gameStatus == .inProgress {
                
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
            correctnessIndicatorView!.isHidden = false
            
            let eventView: EventView? = eventViews.last
            correctnessIndicatorImageViewTopConstraint!.isActive = false
            correctnessIndicatorImageViewTopConstraint = correctnessIndicatorView!.topAnchor.constraint(equalTo: eventView!.bottomAnchor, constant: 19.0)
            correctnessIndicatorImageViewTopConstraint!.isActive = true
            
            var correctnessImage: UIImage? = nil
            if answerStatus == .correct {
                correctnessImage = UIImage(named: "ImageCorrect")
            }
            else if answerStatus == .incorrect {
                correctnessImage = UIImage(named: "ImageIncorrect")
            }
            correctnessIndicatorView!.image = correctnessImage
            correctnessIndicatorView!.sizeToFit()
            
            instructionLabel!.isHidden = false
            instructionLabelTopConstraint!.isActive = false
            instructionLabelTopConstraint = instructionLabel!.topAnchor.constraint(equalTo: correctnessIndicatorView!.bottomAnchor, constant: 9.0)
            instructionLabelTopConstraint!.isActive = true
            instructionLabel!.text = "Tap events to learn more"
        }
        
    }
    
    
    func updateViewWithTimeRemainingString(_ timeRemainingString: String) {
        timerLabel?.text = timeRemainingString
    }
    
    
    func swapEventViewPresentIn(_ positionOne: Int, _ positionTwo: Int) {
        
        //Split this method. It has become too big.
        
        self.eventViews.swapAt(positionOne, positionTwo)
        self.eventViewConstraints.swapAt(positionOne, positionTwo)
        var isLastEventViewUpdated: Bool = false
        
        if (positionOne - 1) >= 0 {
            
            let eventViewForReference: EventView = self.eventViews[positionOne - 1]
            let eventViewToMove: EventView = self.eventViews[positionOne]
            eventViewToMove.eventPosition = positionOne
            
            var constraintToModify: NSLayoutConstraint = eventViewConstraints[positionOne]
            
            constraintToModify.isActive = false
            constraintToModify = eventViewToMove.topAnchor.constraint(equalTo: eventViewForReference.bottomAnchor, constant: 9.0)
            constraintToModify.isActive = true
            
            self.eventViewConstraints.remove(at: positionOne)
            self.eventViewConstraints.insert(constraintToModify, at: positionOne)
            
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
            
            var constraintToModify: NSLayoutConstraint = eventViewConstraints[positionOne]
            
            constraintToModify.isActive = false
            constraintToModify = eventViewToMove.topAnchor.constraint(equalTo: topAnchor, constant: 18.0)
            constraintToModify.isActive = true
            
            self.eventViewConstraints.remove(at: positionOne)
            self.eventViewConstraints.insert(constraintToModify, at: positionOne)
            eventViewToMove.updateMovingDirection(.onlyDown)
            
        }
        
        
        if (positionTwo - 1) >= 0 {
            
            let eventViewForReference: EventView = self.eventViews[positionTwo - 1]
            let eventViewToMove: EventView = self.eventViews[positionTwo]
            eventViewToMove.eventPosition = positionTwo
            
            var constraintToModify: NSLayoutConstraint =  eventViewConstraints[positionTwo]
            
            constraintToModify.isActive = false
            constraintToModify = eventViewToMove.topAnchor.constraint(equalTo: eventViewForReference.bottomAnchor, constant: 9.0)
            constraintToModify.isActive = true
            
            self.eventViewConstraints.remove(at: positionTwo)
            self.eventViewConstraints.insert(constraintToModify, at: positionTwo)
            
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
            var constraintToModify: NSLayoutConstraint =  eventViewConstraints[positionTwo]
            
            constraintToModify.isActive = false
            constraintToModify = eventViewToMove.topAnchor.constraint(equalTo: topAnchor, constant: 18.0)
            constraintToModify.isActive = true
            
            self.eventViewConstraints.remove(at: positionTwo)
            self.eventViewConstraints.insert(constraintToModify, at: positionTwo)
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
            
            var constraintToModify: NSLayoutConstraint =  eventViewConstraints[positionToModify]
            
            constraintToModify.isActive = false
            constraintToModify = eventViewToMove.topAnchor.constraint(equalTo: eventViewForReference.bottomAnchor, constant: 9.0)
            constraintToModify.isActive = true
            
            self.eventViewConstraints.remove(at: positionToModify)
            self.eventViewConstraints.insert(constraintToModify, at: positionToModify)
            
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
    
}
