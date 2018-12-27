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
        let firstEvent: Event = Event(title:"India got independence and we were free from the british and we were very happy actually. Godambi burfi dhsjfhdskjhfkjshd  jshdfjhsjdkhfjksdhfkjds jdshfjkhsdjkfhjksdhfjksdhkjfhs jksdhfjkhsdjkfhsjdkhfjksdhfjksdhjkfhsdjkf dsjkhfjksdhfjks 111", yearItOccurred: 1947)
        let eventView: EventView = EventView(withEvent: firstEvent, positionInGame: 0, eventMovingDirection: .onlyUp)
        view.addSubview(eventView)
        eventView.topAnchor.constraint(equalTo: view.topAnchor, constant: 35.0).isActive = true
        eventView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        eventView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
        eventView.heightAnchor.constraint(equalToConstant: 176.0).isActive = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

