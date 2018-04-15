//
//  ForwardSegue.swift
//  LiveStories
//
//  Created by Jakub Łaszczewski on 11.04.2018.
//  Copyright © 2018 Jakub Łaszczewski. All rights reserved.
//

import UIKit

class ForwardSegue: UIStoryboardSegue {
    override func perform() {
        let sourceView = self.source.view!
        let destinationView = self.destination.view!
        let screenWidth = sourceView.frame.width
        let screenHeight = sourceView.frame.height
        let destinationViewXPosition = -UIScreen.main.bounds.width / 2
        
        destinationView.frame = CGRect(x: sourceView.frame.width, y: sourceView.frame.minY, width: screenWidth, height: screenHeight)
        
        destinationView.addShadow()
        destinationView.layer.shadowOffset = CGSize(width: -7, height: 3)
        destinationView.layer.shadowOpacity = 0.5
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(destinationView, aboveSubview: sourceView)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            sourceView.frame.origin.x = destinationViewXPosition
            destinationView.frame.origin.x = 0
            destinationView.backShadowAnimation(opacityFrom: destinationView.layer.shadowOpacity, offsetFrom: destinationView.layer.shadowOffset, duration: 0.25)
            
        }) { (finish) -> Void in
            customSegue(destinationViewController: self.destination)
        }
    }
}
