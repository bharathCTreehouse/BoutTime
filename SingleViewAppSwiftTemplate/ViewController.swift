//
//  ViewController.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Treehouse on 12/8/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Just to test
        let firstEvent: Event = Event(title:"Start of the Korean war", yearItOccurred: 1947)
        let secondEvent: Event = Event(title:"Start of the Indo-Pak war", yearItOccurred: 1965)
        let thirdEvent: Event = Event(title:"Start of the Indo-China war", yearItOccurred: 1962)
        let fourthEvent: Event = Event(title:"Start of the Kargil war", yearItOccurred: 1999)



        let game: SingleGame = SingleGame(withEventsToArrange: [firstEvent, secondEvent, thirdEvent, fourthEvent])
        let gameView: SingleGameView = SingleGameView(withSingleGame: game)
        
        view.addSubview(gameView)
        if #available(iOS 11.0, *) {
            gameView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0.0).isActive = true
        } else {
            // Fallback on earlier versions
            gameView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        }
        gameView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        gameView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        gameView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

