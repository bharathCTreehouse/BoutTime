//
//  EventView.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Bharath Chandrashekar on 27/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation
import UIKit

enum EventMovingDirection {
    case onlyUp
    case onlyDown
    case upAndDown
}

class EventView: UIView {
    
    @IBOutlet var moveUpButton: UIButton!
    @IBOutlet var moveDownButton: UIButton!
    @IBOutlet var moveOnlyUpButton: UIButton!
    @IBOutlet var moveOnlyDownButton: UIButton!
    @IBOutlet var eventTitleLabel: UILabel!
    
    var eventView: UIView? = nil
    fileprivate var event: EventDisplay? = nil {
        didSet {
            setupEventView()
        }
    }
    var eventPosition: Int? = nil
    var eventMovingDirection: EventMovingDirection? = nil {
        
        //Based on the direction, update the button images.

        didSet {
            updateButtons()
        }
    }
    
    init(withEvent event: EventDisplay, positionInGame: Int, eventMovingDirection: EventMovingDirection) {
        
        eventPosition = positionInGame
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        updateEvent(event)
        updateMovingDirection(eventMovingDirection)
        
}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateMovingDirection(_ direction: EventMovingDirection ) {
        eventMovingDirection = direction
    }
    
    func updateEvent(_ event: EventDisplay) {
        self.event = event
    }
}


extension EventView {
    
    @IBAction func moveEventUpButtonTapped(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func moveEventDownButtonTapped(_ sender: UIButton) {
        
    }
    
}




extension EventView {
    
    func setupEventView() {
        
        if eventView == nil {
            
            //Set it up
            eventView =  (Bundle.main.loadNibNamed("EventView", owner: self, options:nil)?.first as! UIView)
            eventView?.translatesAutoresizingMaskIntoConstraints = false
            addSubview(eventView!)
            eventView?.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            eventView?.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            eventView?.topAnchor.constraint(equalTo: topAnchor).isActive = true
            eventView?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            eventView?.layer.cornerRadius = 5.0
            
        }
        eventTitleLabel.text = event?.eventTitle
    }
    
    
    func updateButtons() {
        
        switch eventMovingDirection! {
            
        case .onlyUp:
            moveOnlyUpButton.isHidden = false
            moveUpButton.isHidden = true
            moveDownButton.isHidden = true
            moveOnlyDownButton.isHidden = true
            
            let normalStateImage: UIImage? = UIImage(named: "UpFullNormal")
            if let normalStateImage = normalStateImage {
                moveOnlyUpButton.setBackgroundImage(normalStateImage, for: .normal)
            }
            
            let selectedStateImage: UIImage? = UIImage(named: "UpFullSelected")
            if let selectedStateImage = selectedStateImage {
                moveOnlyUpButton.setBackgroundImage(selectedStateImage, for: .selected)
            }
            
            moveOnlyUpButton.sizeToFit()
            
            
        case .onlyDown:
            moveOnlyUpButton.isHidden = true
            moveUpButton.isHidden = true
            moveDownButton.isHidden = true
            moveOnlyDownButton.isHidden = false
            
            let normalStateImage: UIImage? = UIImage(named: "DownFullNormal")
            if let normalStateImage = normalStateImage {
                moveOnlyDownButton.setBackgroundImage(normalStateImage, for: .normal)
            }
            
            let selectedStateImage: UIImage? = UIImage(named: "DownFullSelected")
            if let selectedStateImage = selectedStateImage {
                moveOnlyDownButton.setBackgroundImage(selectedStateImage, for: .selected)
            }
            
            moveOnlyDownButton.sizeToFit()
            
        case .upAndDown:
            moveOnlyUpButton.isHidden = true
            moveUpButton.isHidden = false
            moveDownButton.isHidden = false
            moveOnlyDownButton.isHidden = true
            
            let normalStateUpImage: UIImage? = UIImage(named: "UpHalfNormal")
            if let normalStateUpImage = normalStateUpImage {
                moveUpButton.setBackgroundImage(normalStateUpImage, for: .normal)
            }
            
            let selectedStateUpImage: UIImage? = UIImage(named: "UpHalfSelected")
            if let selectedStateUpImage = selectedStateUpImage {
                moveUpButton.setBackgroundImage(selectedStateUpImage, for: .selected)
            }
            
            let normalStateDownImage: UIImage? = UIImage(named: "DownHalfNormal")
            if let normalStateDownImage = normalStateDownImage {
                moveDownButton.setBackgroundImage(normalStateDownImage, for: .normal)
            }
            
            let selectedStateDownImage: UIImage? = UIImage(named: "DownHalfSelected")
            if let selectedStateDownImage = selectedStateDownImage {
                moveDownButton.setBackgroundImage(selectedStateDownImage, for: .selected)
            }
            
            moveUpButton.sizeToFit()
            moveDownButton.sizeToFit()
        }
    }
    
}
