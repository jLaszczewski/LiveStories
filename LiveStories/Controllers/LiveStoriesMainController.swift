//
//  ViewController.swift
//  LiveStories
//
//  Created by Jakub Łaszczewski on 11.04.2018.
//  Copyright © 2018 Jakub Łaszczewski. All rights reserved.
//

import UIKit

class LiveStoriesMainController: UIViewController {
    var swipeBack = SwipeBack()
    var swipeGestureRecognizer: UIPanGestureRecognizer!
    
    var swipeFront = SwipeFront()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned))
        self.view.addGestureRecognizer(swipeGestureRecognizer)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func imagePressed(_ sender: Any) {
        let imagePopover = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "imagePopover") as! ImagePopoverViewController

        imagePopover.view.frame = CGRect(x: 0, y: 0, width: super.view.bounds.width, height: super.view.bounds.height)
        self.addChildViewController(imagePopover)
        self.view.addSubview(imagePopover.view)
        imagePopover.didMove(toParentViewController: self)
        
    }
    @IBAction func panned(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.location(in: self.view).x <= 0.3 * UIScreen.main.bounds.size.width {
            let gestureState = swipeBack.backSwipe(gestureRecognizer: gestureRecognizer, sourceViewController: self)
            switch gestureState {
            case .cancelled, .ended, .failed:
                swipeBack = SwipeBack()
            default:
                break
            }
        } else if gestureRecognizer.location(in: self.view).x >= 0.3 * UIScreen.main.bounds.size.width {
            let gestureState = swipeFront.frontSwipe(gestureRecognizer: gestureRecognizer, sourceViewController: self)
            switch gestureState {
            case .cancelled, .ended, .failed:
                swipeFront = SwipeFront()
            default:
                break
            }
        }
    }

}

