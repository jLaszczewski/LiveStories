//
//  customSegue.swift
//  Daimo
//
//  Created by Dhiān Ekatāl on 24.07.2017.
//  Copyright © 2017 myProject. All rights reserved.
//

import UIKit

public func customSegue(destinationViewController: UIViewController) {
    let destinationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: destinationViewController.restorationIdentifier!)
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = destinationViewController
    window.makeKeyAndVisible()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        AppDelegate.shared.window = window
    }
}
