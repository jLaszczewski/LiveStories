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
    @IBOutlet weak var imageButton: UIImageView!
    @IBOutlet weak var titleLabels: UILabel!
    @IBOutlet weak var titleBar: UIView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var lastButton: UIBarButtonItem!
    @IBOutlet weak var firstButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var swipeBack = SwipeBack()
    var swipeGestureRecognizer: UIPanGestureRecognizer!
    
    var swipeFront = SwipeFront()
    var num: Int!

    var transcript = [Message]()
    var currentAuthor: String!
    var authors = [Author]()
    var isLeft = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned))
        self.view.addGestureRecognizer(swipeGestureRecognizer)
        
        storiesTableView.delegate = self
        storiesTableView.dataSource = self
        
        imageButton.isHidden = true
        
        titleBar.addShadow()
        titleBar.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        num = AppDelegate.shared.num
        
        if num == 1 {
            backButton.isEnabled = false
        }
        
        if num == 1980 {
            nextButton.isEnabled = false
        }
        
        APIRequest(for: num) { (liveStory, error) in
            if let liveStory = liveStory {
                self.transcript = liveStory.transcript.components(separatedBy: "\n").map { self.getMessage(from: $0) }
                
                DispatchQueue.main.async {
                    self.storiesTableView.reloadData()
                }
                
                self.load_image(liveStory.img) { (image) in
                    if let image = image {
                        DispatchQueue.main.async {
                            self.imageButton.image = image
                            self.imageButton.isHidden = false
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.titleLabels.text = liveStory.title
                }
            }
        }
    }
    
    func getMessage(from text: String) -> Message {
        let typeOfBrackets = [["<<", ">>"], ["[[", "]]"], ["{{", "}}"], ["((", "))"], ["<<", ">>"],]
        
        for breacket in typeOfBrackets {
            if let text = text.slice(from: breacket[0], to: breacket[1])  {
                if let author = text.slice(to: ": "), let content = text.slice(from: ": ") {
                    return Message(content: content, author: author, type: .comment)
                }
                return Message(content: text, author: nil, type: .comment)
            }
        }
        if let author = text.slice(to: ": "), let content = text.slice(from: ": ") {
            if author.lowercased() == "narrator" {
                return Message(content: content, author: author, type: .comment)
            }
            if currentAuthor != author {
                isLeft = !isLeft
                currentAuthor = author
            }
            if isLeft {
                return Message(content: content, author: author, type: .leftVoice)
            }
            return Message(content: content, author: author, type: .rightVoice)
            
        }
        return Message(content: text, author: nil, type: .comment)
    }
    
    func load_image(_ imageUrlString: String, completionHandler: @escaping (UIImage?) -> Void ) {
        if let url = URL(string: imageUrlString) {
            let data = try? Data(contentsOf: url)
            
            if let imageData = data {
                completionHandler(UIImage(data: imageData))
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
        
        imagePopover.imageView.image = imageButton.image
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transcript.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryCell", for: indexPath) as! StoryCell
        let currentMessage = transcript[indexPath.row]
        
        if let author = currentMessage.author, currentMessage.type != .comment {
            cell.authorLabel.text = author
            cell.authorLabelHeight.constant = 25
            if let i = authors.index(where: { $0.name == author }) {
                cell.messageView.backgroundColor = authors[i].colour
                cell.rightCorner.backgroundColor = authors[i].colour
                cell.leftCorner.backgroundColor = authors[i].colour
            } else {
                let colour = createColour()
                cell.messageView.backgroundColor = colour
                cell.rightCorner.backgroundColor = colour
                cell.leftCorner.backgroundColor = colour
                isLeft = !isLeft
                
                let newAuthor = Author(name: author, colour: colour)
                authors.append(newAuthor)
            }
        } else {
             cell.authorLabel.text = ""
             cell.authorLabelHeight.constant = 0
             cell.messageView.backgroundColor = .lightGray
        }
        
        switch currentMessage.type {
        case .comment:
            cell.leftMarginGreaterThan.constant = 50
            cell.leftMarginGreaterThan.priority = UILayoutPriority(rawValue: 999)
            cell.rightMarginGraterThan.constant = 50
            cell.rightMarginGraterThan.priority = UILayoutPriority(rawValue: 999)
            cell.rightMargin.priority = UILayoutPriority(rawValue: 1)
            cell.leftMargin.priority = UILayoutPriority(rawValue: 1)
            cell.messageView.backgroundColor = .lightGray
            cell.leftCorner.isHidden = true
            cell.rightCorner.isHidden = true
        case .leftVoice:
            cell.leftMargin.priority = UILayoutPriority(rawValue: 999)
            cell.rightMarginGraterThan.constant = 75
            cell.rightMarginGraterThan.priority = UILayoutPriority(rawValue: 999)
            cell.leftMarginGreaterThan.priority = UILayoutPriority(rawValue: 1)
            cell.rightMargin.priority = UILayoutPriority(rawValue: 1)
            cell.leftCorner.isHidden = false
            cell.rightCorner.isHidden = true
        case .rightVoice:
            cell.rightMarginGraterThan.priority = UILayoutPriority(rawValue: 1)
            cell.leftMarginGreaterThan.constant = 75
            cell.leftMarginGreaterThan.priority = UILayoutPriority(rawValue: 999)
            cell.leftMargin.priority = UILayoutPriority(rawValue: 1)
            cell.rightMargin.priority = UILayoutPriority(rawValue: 999)
            cell.leftCorner.isHidden = true
            cell.rightCorner.isHidden = false
        }

        cell.contentLabel.text = currentMessage.content
        
        return cell
    }
    
    func createColour() -> UIColor {
        switch authors.count {
        case 0:
            return .cyan
        case 1:
            return .yellow
        case 2:
            return .green
        case 3:
            return .orange
        case 4:
            return .red
        case 5:
            return .purple
        case 6:
            return .blue
        case 7:
            return .magenta
        default:
            return .lightGray
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "backSegue":
            AppDelegate.shared.num = self.num - 1
        case "firstSegue":
             AppDelegate.shared.num = 1
        case "lastSegue":
             AppDelegate.shared.num = 1980
        case "nextSegue":
             AppDelegate.shared.num = self.num + 1
        default:
            break
        }
    }
    
    @IBAction func panned(gestureRecognizer: UIPanGestureRecognizer) {
        
        if gestureRecognizer.location(in: self.view).x <= 0.4 * UIScreen.main.bounds.size.width {
            if num > 1 {
                let gestureState = swipeBack.backSwipe(gestureRecognizer: gestureRecognizer, sourceViewController: self)
                switch gestureState {
                case .cancelled, .ended, .failed:
                    swipeBack = SwipeBack()
                default:
                    break
                }
            }
        } else if gestureRecognizer.location(in: self.view).x >= 0.4 * UIScreen.main.bounds.size.width {
            if num < 1980 {
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
    
}

