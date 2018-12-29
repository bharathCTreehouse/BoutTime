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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Just to test
        let firstEvent: Event = Event(title:"Start of the Korean war", yearItOccurred: 1947)
        let secondEvent: Event = Event(title:"Start of the Indo-Pak war", yearItOccurred: 1965)
        let thirdEvent: Event = Event(title:"Start of the Indo-China war", yearItOccurred: 1962)
        let fourthEvent: Event = Event(title:"Start of the Kargil war", yearItOccurred: 1999)



        let game: SingleGame = SingleGame(withEventsToArrange: [firstEvent, secondEvent, thirdEvent, fourthEvent])
        currentGameView = SingleGameView(withSingleGame: game)
        
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

        
    }
    
    
    func eventDirectionButtonTapped(_ sender: Notification) {
        
        let direction: EventMovingDirection = (sender.userInfo!["direction"]) as! EventMovingDirection
        let position: Int = (sender.userInfo!["position"]) as! Int
        
        var updatedPosition = position
        if direction == .onlyUp {
            updatedPosition = position - 1
            self.currentGameView?.singleGame?.reorderEventsAt(firstPosition: updatedPosition, secondPosition: position)

        }
        else if direction == .onlyDown {
            updatedPosition = position + 1
            self.currentGameView?.singleGame?.reorderEventsAt(firstPosition: position, secondPosition: updatedPosition)

        }
        
    }

   

}

