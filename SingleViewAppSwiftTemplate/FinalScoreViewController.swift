//
//  FinalScoreViewController.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Bharath Chandrashekar on 31/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation
import UIKit

class FinalScoreViewController: UIViewController {
    
    @IBOutlet var finalScoreLabel: UILabel!
    var userScore: Int = 0
    var gameCount: Int = 0
    var playAgainClosure: (() -> Void)? = nil
    
    
    init(withUserScore score: Int, numberOfGames: Int,  playAgainCompletionHandler: @escaping (() -> Void) ) {
        userScore = score
        gameCount = numberOfGames
        playAgainClosure = playAgainCompletionHandler
        super.init(nibName: "FinalScoreViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        finalScoreLabel.text = "\(userScore)/\(gameCount)"
    }
    
    
    @IBAction func playAgainButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: ( { [unowned self] () -> Void in
            self.playAgainClosure?()
        }))
    }
    
    deinit {
        finalScoreLabel = nil
        playAgainClosure = nil
    }
}
