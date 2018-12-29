//
//  Timer.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Bharath Chandrashekar on 30/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

protocol TimerProtocol: class {
    func updateWithCurrentTimerValue(_ value: Int)
}

enum TimerDirection {
    case forward
    case reverse
}


class EventTimer {
    
    fileprivate var timerValue: Int = 0
    fileprivate var timerDirection: TimerDirection = .forward
    fileprivate weak var delegate: TimerProtocol? = nil
    fileprivate var timer: Timer? = nil
    
    init(withInitialValue value: Int, direction: TimerDirection, delegate: TimerProtocol) {
        
        timerValue = value
        timerDirection = direction
        self.delegate = delegate
    }
    
    
    func update(withInitialValue value: Int, direction: TimerDirection, delegate: TimerProtocol) {
        
        timerValue = value
        timerDirection = direction
        self.delegate = delegate
    }
    
    
    func initiateTimer() {
        
        invalidateTimer()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerActionTrigger(_:)), userInfo: nil, repeats: true)
    }
    
    
    func invalidateTimer() {
        
        timer?.invalidate()
        timer = nil
    }
    
    
    @objc func timerActionTrigger(_ timer: Timer) {
        
        if timerDirection == .forward {
            timerValue = timerValue + 1
        }
        else if timerDirection == .reverse {
            timerValue = timerValue - 1
        }
        delegate?.updateWithCurrentTimerValue(timerValue)
        
    }
    
}
