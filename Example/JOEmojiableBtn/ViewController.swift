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
    var labelInfo:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label           = UILabel(frame: CGRectMake(0,30,self.view.frame.width,30))
        label.text          = "Long tap in the buttons"
        label.textColor     = UIColor.lightGrayColor()
        label.textAlignment = .Center
        self.view.addSubview(label)
        
        labelInfo           = UILabel(frame: CGRectMake(0,60,self.view.frame.width,30))
        labelInfo.text          = ""
        labelInfo.textColor     = UIColor(red:0.27, green:0.69, blue:0.67, alpha:1)
        labelInfo.textAlignment = .Center
        self.view.addSubview(labelInfo)
        
        
        let btn                = JOEmojiableBtn(frame: CGRectMake(40,200,100,50))
        btn.delegate           = self
        btn.titleLabel?.font   = UIFont.systemFontOfSize(11)
        btn.backgroundColor    = UIColor(red:0.27, green:0.69, blue:0.67, alpha:1)
        btn.layer.cornerRadius = 25
        btn.setTitle("Long-tap me!", forState: .Normal)
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
        let btn2                = JOEmojiableBtn(frame: CGRectMake(40,300,100,50), config: config)
        btn2.delegate           = self
        btn2.backgroundColor    = UIColor(red:0.27, green:0.69, blue:0.67, alpha:1)
        btn2.layer.cornerRadius = 25
        btn2.titleLabel?.font   = UIFont.systemFontOfSize(11)
        btn2.setTitle("Long-tap me!", forState: .Normal)
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
        labelInfo.text = "Single tap action"
    }
    
    func selectedOption(sender: JOEmojiableBtn, index: Int) {
        print("Option \(index) selected")
        labelInfo.text = "Option \(index) selected"
    }
    
    func canceledAction(sender: JOEmojiableBtn) {
        print("User cancelled selection")
        labelInfo.text = "User cancelled selection"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

