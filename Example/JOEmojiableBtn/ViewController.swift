//
//  ViewController.swift
//  JOEmojiableBtn
//
//  Created by Jorge Raul Ovalle Zuleta on 2/28/16.
//  Copyright © 2016 jorgeovalle. All rights reserved.
//

import UIKit
import JOEmojiableBtn


class ViewController: UIViewController,JOEmojiableDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let btn                = JOEmojiableBtn(frame: CGRectMake(40,200,50,50))
        btn.delegate           = self
        btn.backgroundColor    = UIColor(red:0.27, green:0.69, blue:0.67, alpha:1)
        btn.layer.cornerRadius = 25
        btn.dataset            = [
            JOEmojiableOption(image: "img_1", name: "dislike"),
            JOEmojiableOption(image: "img_2", name: "broken"),
            JOEmojiableOption(image: "img_3", name: "he he"),
            JOEmojiableOption(image: "img_4", name: "ooh"),
            JOEmojiableOption(image: "img_5", name: "meh!"),
            JOEmojiableOption(image: "img_6", name: "ahh!")
        ]
        self.view.addSubview(btn)
        

        let config              = JOEmojiableConfig(spacing: 2, size: 30, minSize: 34, maxSize: 45, s_options_selector: 30)
        let btn2                = JOEmojiableBtn(frame: CGRectMake(40,300,50,50), config: config)
        btn2.delegate           = self
        btn2.backgroundColor    = UIColor(red:0.27, green:0.69, blue:0.67, alpha:1)
        btn2.layer.cornerRadius = 25
        btn2.dataset            = [
            JOEmojiableOption(image: "img_1", name: "dislike"),
            JOEmojiableOption(image: "img_2", name: "broken"),
            JOEmojiableOption(image: "img_3", name: "he he"),
            JOEmojiableOption(image: "img_4", name: "ooh"),
            JOEmojiableOption(image: "img_5", name: "meh!"),
            JOEmojiableOption(image: "img_6", name: "ahh!"),
            JOEmojiableOption(image: "img_4", name: "ooh")
        ]
        self.view.addSubview(btn2)
        
        
    }
    
    func singleTap(sender: JOEmojiableBtn) {
        print("Single tap action")
    }
    
    func selectedOption(sender: JOEmojiableBtn, index: Int) {
        print("Option \(index) selected")
    }
    
    func canceledAction(sender: JOEmojiableBtn) {
        print("User cancelled selection")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

