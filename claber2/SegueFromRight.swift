//
//  ViewController.swift
//  claber2
//
//  Created by Ognjen Tomić on 6/7/17.
//  Copyright © 2017 Ognjen Tomić. All rights reserved.
//


import UIKit

class TransitionFromRight: UIStoryboardSegue {
    
    override func perform() {
        
        let src = self.source
        let dst = self.destination
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.35
        transition.timingFunction = timeFunc
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromRight 
        
        src.view.window?.layer.add(transition, forKey: nil)
        src.present(dst, animated: false, completion: nil)
        
        
    }
    
    
}
