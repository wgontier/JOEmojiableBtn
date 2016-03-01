# JOEmojiableBtn

[![CI Status](http://img.shields.io/travis/Jorge Ovalle/JOEmojiableBtn.svg?style=flat)](https://travis-ci.org/Jorge Ovalle/JOEmojiableBtn)
[![Version](https://img.shields.io/cocoapods/v/JOEmojiableBtn.svg?style=flat)](http://cocoapods.org/pods/JOEmojiableBtn)
[![License](https://img.shields.io/cocoapods/l/JOEmojiableBtn.svg?style=flat)](http://cocoapods.org/pods/JOEmojiableBtn)
[![Platform](https://img.shields.io/cocoapods/p/JOEmojiableBtn.svg?style=flat)](http://cocoapods.org/pods/JOEmojiableBtn)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.


![image](http://imgur.com/e4zaaye)


![image](http://imgur.com/yNfyP3c)

```swift
let btn             = JOEmojiableBtn(frame: CGRectMake(40,200,50,50))
btn.delegate        = self
btn.backgroundColor = UIColor.greenColor()
btn.dataset         = [
    JOEmojiableOption(image: "img_1", name: "dislike"),
    JOEmojiableOption(image: "img_2", name: "broken"),
    JOEmojiableOption(image: "img_3", name: "he he"),
    JOEmojiableOption(image: "img_4", name: "ooh"),
    JOEmojiableOption(image: "img_5", name: "meh!"),
    JOEmojiableOption(image: "img_6", name: "ahh!")
]
self.view.addSubview(btn)
```





## Requirements

## Installation

JOEmojiableBtn is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JOEmojiableBtn"
```

## Author

Jorge Ovalle, jroz9105@gmail.com

## License

JOEmojiableBtn is available under the MIT license. See the LICENSE file for more info.
