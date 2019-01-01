//
//  ViewAdditions.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Bharath Chandrashekar on 02/01/19.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func safeAreaLayoutGuideToBeUsed() -> UILayoutGuide? {
        
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide
        }
        else {
            return nil
        }
        
    }
    
}
