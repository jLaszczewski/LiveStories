//
//  BackwardSegue.swift
//  LiveStories
//
//  Created by Jakub Łaszczewski on 11.04.2018.
//  Copyright © 2018 Jakub Łaszczewski. All rights reserved.
//

import UIKit

class BackwardSegue: UIStoryboardSegue {
    override func perform() {
        let sourceView = self.source.view!
        let destinationView = self.destination.view!
        let screenWidth = sourceView.frame.width
        let screenHeight = sourceView.frame.height
        let destinationViewXPosition = -UIScreen.main.bounds.width / 2
        
        destinationView.frame =  CGRect(x: destinationViewXPosition, y: sourceView.frame.minY, width: screenWidth, height: screenHeight)
        
        sourceView.addShadow()
        sourceView.layer.shadowOffset = CGSize(width: -7, height: 3)
        sourceView.layer.shadowOpacity = 0.5
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(destinationView, belowSubview: sourceView)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            sourceView.frame.origin.x = screenWidth
            destinationView.frame.origin.x = 0
            sourceView.backShadowAnimation(opacityFrom: sourceView.layer.shadowOpacity, offsetFrom: sourceView.layer.shadowOffset, duration: 0.25)
            
        }) { (finish) -> Void in
            customSegue(destinationViewController: self.destination)
        }
        
    }
}
