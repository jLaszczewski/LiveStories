//
//  ViewController.swift
//  LiveStories
//
//  Created by Jakub Łaszczewski on 11.04.2018.
//  Copyright © 2018 Jakub Łaszczewski. All rights reserved.
//

import UIKit

class LiveStoriesMainController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var storiesTableView: UITableView!
    
    var swipeBack = SwipeBack()
    var swipeGestureRecognizer: UIPanGestureRecognizer!
    
    var swipeFront = SwipeFront()
    var liveStory: LiveStory!
    var num: Int = 208
    var story = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned))
        self.view.addGestureRecognizer(swipeGestureRecognizer)
        
        APIRequest(for: num) { (liveStory, error) in
            if error == nil && liveStory != nil {
                self.liveStory = liveStory
                print(self.liveStory.transcript)
            }
        }
        
    }
    
    func APIRequest(for num: Int, completionHandler: @escaping (LiveStory?, Error?) -> Void ) {
        let urlString = LiveStory.endpointFor(num)
        if let url = URL(string: urlString) {
            let urlRequest = URLRequest(url: url)
            
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if error == nil {
                    if let responseData = data {
                        let decoder = JSONDecoder()
                        do {
                            let liveStory = try decoder.decode(LiveStory.self, from: responseData)
                            completionHandler(liveStory, nil)
                        } catch {
                            print("error trying to convert data to JSON")
                            print(error)
                            completionHandler(nil, error)
                        }
                    }
                }
            })
            task.resume()
        }
    }
    
    @IBAction func imagePressed(_ sender: Any) {
        let imagePopover = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "imagePopover") as! ImagePopoverViewController
        
        imagePopover.view.frame = CGRect(x: 0, y: 0, width: super.view.bounds.width, height: super.view.bounds.height)
        self.addChildViewController(imagePopover)
        self.view.addSubview(imagePopover.view)
        imagePopover.didMove(toParentViewController: self)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return story.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryCell", for: indexPath) as! StoryCell
        
        return cell
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

