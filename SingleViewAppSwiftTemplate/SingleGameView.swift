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
            hideGameInformationView(true)
        }
    }
    var instructionLabelTopConstraint: NSLayoutConstraint? = nil
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
        singleGame?.userInterfaceUpdateDelegate = self
        beginGame()
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
            timerLabel?.font = UIFont.systemFont(ofSize: 40.0, weight: UIFontWeightRegular)
            addSubview(timerLabel!)
            timerLabel!.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            let eventView: EventView? = eventViews.last
            timerLabel!.topAnchor.constraint(equalTo: eventView!.bottomAnchor, constant: 20.0).isActive = true
            
        }
        
    }
    
    func setupCorrectnessIndicatorView() {
        
        if correctnessIndicatorView == nil {
            correctnessIndicatorView = UIImageView(image: nil)
            correctnessIndicatorView!.translatesAutoresizingMaskIntoConstraints = false
            addSubview(correctnessIndicatorView!)
            correctnessIndicatorView!.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            let eventView: EventView? = eventViews.last
            correctnessIndicatorView!.topAnchor.constraint(equalTo: eventView!.bottomAnchor, constant: 7.0).isActive = true
            
        }
        
    }
    
    func setupInstructionLabel() {
        
        if instructionLabel == nil {
            instructionLabelTopConstraint?.isActive = false
            instructionLabel = UILabel()
            instructionLabel!.numberOfLines = 0
            instructionLabel!.translatesAutoresizingMaskIntoConstraints = false
            instructionLabel!.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightRegular)
            instructionLabel!.textColor = UIColor(red: 0.0, green: 111.0/255.0, blue: 148.0/255.0, alpha: 1.0)
            addSubview(instructionLabel!)
            instructionLabelTopConstraint = instructionLabel!.topAnchor.constraint(equalTo: timerLabel!.bottomAnchor, constant: 6.0)
            instructionLabelTopConstraint?.isActive = true
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
    
    func beginGame() {
        singleGame?.begin()
    }
}


extension SingleGameView: GameStatusUpdateProtocol {
    
    
    func updateViewForGameStatus(_ gameStatus: GameStatus) {
        
        if gameStatus == .inProgress {
            
            timerLabel!.isHidden = false
            updateViewWithTimeRemainingString("0:60")
            
            instructionLabel!.isHidden = false
            instructionLabelTopConstraint!.isActive = false
            instructionLabelTopConstraint = instructionLabel!.topAnchor.constraint(equalTo: timerLabel!.bottomAnchor, constant: 6.0)
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
    
    func updateViewForGameAnswerStatus(_ answerStatus: GameAnswerStatus) {
        
        timerLabel!.isHidden = true
        var correctnessImage: UIImage? = nil
        if answerStatus == .correct {
            correctnessImage = UIImage(named: "ImageCorrect")
        }
        else if answerStatus == .incorrect {
            correctnessImage = UIImage(named: "ImageIncorrect")
        }
        correctnessIndicatorView?.image = correctnessImage
        
        instructionLabel!.isHidden = false
        instructionLabelTopConstraint!.isActive = false
        instructionLabelTopConstraint = instructionLabel!.topAnchor.constraint(equalTo: correctnessIndicatorView!.bottomAnchor, constant: 6.0)
        instructionLabelTopConstraint!.isActive = true
        instructionLabel!.text = "Tap events to learn more"
        
    }
    
    func updateViewWithTimeRemainingString(_ timeRemainingString: String) {
        timerLabel?.text = timeRemainingString
    }
}
