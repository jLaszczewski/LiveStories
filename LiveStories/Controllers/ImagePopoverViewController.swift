//
//  ImagePopoverViewController.swift
//  LiveStories
//
//  Created by Jakub Łaszczewski on 12.04.2018.
//  Copyright © 2018 Jakub Łaszczewski. All rights reserved.
//

import UIKit

class ImagePopoverViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backPressed(_ sender: Any) {
        self.view.removeFromSuperview()
    }
}
