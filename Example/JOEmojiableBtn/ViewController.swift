//
//  ViewController.swift
//  JOEmojiableBtn
//
//  Created by Jorge Raul Ovalle Zuleta on 2/28/16.
//  Copyright © 2016 jorgeovalle. All rights reserved.
//

import UIKit
import JOEmojiableBtn

class ViewController: UIViewController, JOEmojiableDelegate {
    var labelInfo: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel(frame: CGRect(x: 0, y: 30, width: self.view.frame.width, height: 30))
        label.text = "Long tap in the buttons"
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        self.view.addSubview(label)

        labelInfo = UILabel(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: 30))
        labelInfo.text = ""
        labelInfo.textColor = UIColor(red: 0.27, green: 0.69, blue: 0.67, alpha: 1)
        labelInfo.textAlignment = .center
        self.view.addSubview(labelInfo)

        let btn = JOEmojiableBtn(frame: CGRect(x: 40, y: 200, width: 100, height: 50))
        btn.delegate = self
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        btn.backgroundColor = UIColor(red: 0.27, green: 0.69, blue: 0.67, alpha: 1)
        btn.layer.cornerRadius = 25
        btn.setTitle("Long-tap me!", for: [.normal])
        btn.dataset = [
            JOEmojiableOption(image: "img_1", name: "dislike"),
            JOEmojiableOption(image: "img_2", name: "broken"),
            JOEmojiableOption(image: "img_3", name: "he he"),
            JOEmojiableOption(image: "img_4", name: "ooh"),
            JOEmojiableOption(image: "img_5", name: "meh!"),
            JOEmojiableOption(image: "img_6", name: "ahh!")
        ]
        self.view.addSubview(btn)

        let config = JOEmojiableConfig(spacing: 2, size: 30, minSize: 34, maxSize: 45, s_options_selector: 30)
        let btn2 = JOEmojiableBtn(frame: CGRect(x: 40, y: 300, width: 100, height: 50), config: config)
        btn2.delegate = self
        btn2.backgroundColor = UIColor(red: 0.27, green: 0.69, blue: 0.67, alpha: 1)
        btn2.layer.cornerRadius = 25
        btn2.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        btn2.setTitle("Long-tap me!", for: [.normal])
        btn2.dataset = [
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

    func singleTap(_ sender: JOEmojiableBtn) {
        print("Single tap action")
        labelInfo.text = "Single tap action"
    }

    func selectedOption(_ sender: JOEmojiableBtn, index: Int) {
        print("Option \(index) selected")
        labelInfo.text = "Option \(index) selected"
    }

    func canceledAction(_ sender: JOEmojiableBtn) {
        print("User cancelled selection")
        labelInfo.text = "User cancelled selection"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
