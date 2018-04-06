//
//  JOEmojiableBtn.swift
//  JOEmojiableBtn
//
//  Created by Jorge Raul Ovalle Zuleta on 2/28/16.
//  Copyright © 2018 Jorge Ovalle. All rights reserved.
//

import UIKit

public struct JOEmojiableOption {
    var image: String
    var name: String

    public init(image: String, name: String) {
        self.image = image
        self.name  = name
    }
}

public protocol JOEmojiableDelegate: class {
    func selectedOption(_ sender: JOEmojiableBtn, index: Int)
    func singleTap(_ sender: JOEmojiableBtn)
    func canceledAction(_ sender: JOEmojiableBtn)
}

open class JOEmojiableBtn: UIButton {
    open weak var delegate: JOEmojiableDelegate!
    open var dataset: [JOEmojiableOption]!

    private lazy var longTap: UILongPressGestureRecognizer = {
        return UILongPressGestureRecognizer(target: self, action: #selector(JOEmojiableBtn.longTapEvent))
    }()
    
    private lazy var singleTap: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(JOEmojiableBtn.singleTapEvent))
    }()

    var active: Bool!
    var selectedItem: Int!
    var bgClear: SelectorView!
    var options: UIView!
    var origin: CGPoint!

    var information: InformationView!

    let config: JOEmojiableConfig

    /**
     Initialization with Custom sizes check Documentation Github project
     
     - parameter frame: Frame of the button will open the selector
     - parameter config: JOEmojiableConfig value with custom sizes
     */

    public init(frame: CGRect, config: JOEmojiableConfig = .default) {
        self.config = config
        super.init(frame: frame)
        
        
        
        addGestureRecognizer(longTap)
        addGestureRecognizer(singleTap)
        layer.masksToBounds = false
        active = false
    }

    func longTapEvent() {
        activate()
    }

    func singleTapEvent() {
        activate()
    }

    /**
     Function that open the Options Selector
     */
    fileprivate func activate() {
        if !active {
            if dataset != nil {
                let frameSV = UIScreen.main.bounds
                selectedItem = -1
                active = true
                bgClear = SelectorView(frame: frameSV)
                bgClear.delegate = self
                bgClear.backgroundColor = .clear

                origin = superview?.convert(self.frame.origin, to: nil)

                if origin != frame.origin {
                    bgClear.frame.origin.x -= origin.x
                    bgClear.frame.origin.y -= origin.y
                }

                self.superview?.addSubview(bgClear)

                let sizeBtn = CGSize(width: ((CGFloat(dataset.count + 1) * config.spacing) + (config.size * CGFloat(dataset.count))), height: config.size + (2 * config.spacing))
                options = UIView(frame: CGRect(x: origin.x, y: origin.y - (sizeBtn.height), width: sizeBtn.width, height: sizeBtn.height))
                options.layer.cornerRadius  = options.frame.height/2
                options.backgroundColor     = .white
                options.layer.shadowColor   = UIColor.lightGray.cgColor
                options.layer.shadowOffset  = .zero
                options.layer.shadowOpacity = 0.5
                options.alpha               = 0.3
                bgClear.addSubview(options)

                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.options.frame.origin.y = self.origin.y - (self.config.s_options_selector + sizeBtn.height)
                    self.options.alpha = 1
                })

                for i in 0..<dataset.count {
                    let option = UIImageView(frame: CGRect(x: (CGFloat(i + 1) * config.spacing) + (config.size * CGFloat(i)), y: sizeBtn.height * 1.2, width: 10, height: 10))
                    option.image = UIImage(named: dataset[i].image)
                    option.alpha = 0.6
                    options.addSubview(option)
                    UIView.animate(withDuration: 0.2, delay: 0.05 * Double(i), options: .curveEaseInOut, animations: { () -> Void in
                        option.frame.origin.y = self.config.spacing
                        option.alpha = 1
                        option.frame.size = CGSize(width: self.config.size, height: self.config.size)
                        option.center = CGPoint(x: (CGFloat(i + 1) * self.config.spacing) + (self.config.size * CGFloat(i)) + self.config.size / 2, y: self.config.spacing + self.config.size / 2)
                    }, completion: nil)
                }

                information = InformationView(frame: CGRect(x: 0, y: origin.y, width: frameSV.width, height: self.frame.height))
                information.backgroundColor = .white
                bgClear.addSubview(information)
            } else {
                print("Please, initialize the dataset.")
            }
        }
    }

    /**
     Function that close the Options Selector
     */
    fileprivate func deActivate(_ optionIdx: Int) {
        for (i, option) in self.options.subviews.enumerated() {
            UIView.animate(withDuration: 0.2, delay: 0.05 * Double(i), options: UIViewAnimationOptions.curveEaseInOut, animations: { () -> Void in
                self.information.alpha = 0
                option.alpha = 0.3
                option.frame.size = CGSize(width: 10, height: 10)
                if optionIdx == i {
                    option.center = CGPoint(x: (CGFloat(i + 1) * self.config.spacing) + (self.config.size * CGFloat(i)) + self.config.size / 2, y: -self.options.frame.height + self.config.size / 2)
                } else {
                    option.center = CGPoint(x: (CGFloat(i + 1) * self.config.spacing) + (self.config.size * CGFloat(i)) + self.config.size / 2, y: self.options.frame.height + self.config.size / 2)
                }
            }, completion: { (finished) -> Void in
                if finished && i == (self.dataset.count / 2) {
                    UIView.animate(withDuration: 0.1, animations: { () -> Void in
                        self.options.alpha = 0
                        self.options.frame.origin.y = self.origin.y - (self.config.size + (2 * self.config.spacing))
                    }, completion: { (finished) -> Void in
                        self.active = false
                        self.bgClear.removeFromSuperview()
                        if optionIdx < 0 {
                            self.delegate.canceledAction(self)
                        } else {
                            self.delegate.selectedOption(self, index: self.selectedItem)
                        }
                    })
                }
            })
        }
    }

    fileprivate func loseFocus() {
        selectedItem = -1
        information.activateInfo(true)
        UIView.animate(withDuration: 0.3) { () -> Void in
            let sizeBtn = CGSize(width: ((CGFloat(self.dataset.count + 1) * self.config.spacing) + (self.config.size * CGFloat(self.dataset.count))), height: self.config.size + (2 * self.config.spacing))
            self.options.frame = CGRect(x: self.origin.x, y: self.origin.y - (self.config.s_options_selector + sizeBtn.height), width: sizeBtn.width, height: sizeBtn.height)
            self.options.layer.cornerRadius = sizeBtn.height / 2
            for (idx, view) in self.options.subviews.enumerated() {
                view.frame = CGRect(x: (CGFloat(idx + 1) * self.config.spacing) + (self.config.size * CGFloat(idx)), y: self.config.spacing, width: self.config.size, height: self.config.size)
            }
        }
    }

    func selectIndex(_ index: Int) {
        if index >= 0 && index < dataset.count {
            selectedItem = index
            information.activateInfo(false)

            UIView.animate(withDuration: 0.3) { () -> Void in
                let sizeBtn = CGSize(width: ((CGFloat(self.dataset.count - 1) * self.config.spacing) + (self.config.minSize * CGFloat(self.dataset.count - 1)) + self.config.maxSize), height: self.config.minSize + (2 * self.config.spacing))
                self.options.frame = CGRect(origin: CGPoint(x: self.origin.x,
                                                            y: self.origin.y - (self.config.s_options_selector + sizeBtn.height)),
                                            size: sizeBtn)
                self.options.layer.cornerRadius = sizeBtn.height / 2
                var last: CGFloat = index != 0 ? self.config.spacing : 0
                for (idx, view) in self.options.subviews.enumerated() {
                    switch idx {
                    case (index-1):
                        view.frame = CGRect(x: last, y: self.config.spacing, width: self.config.minSize, height: self.config.minSize)
                        view.center.y = (self.config.minSize / 2) + self.config.spacing
                        last += self.config.minSize
                    case (index):
                        view.frame = CGRect(x: last, y: -(self.config.maxSize / 2), width: self.config.maxSize, height: self.config.maxSize)
                        last += self.config.maxSize
                    default:
                        view.frame = CGRect(x: last, y: self.config.spacing, width: self.config.minSize, height: self.config.minSize)
                        view.center.y = (self.config.minSize / 2) + self.config.spacing
                        last += self.config.minSize + self.config.spacing
                    }
                }
            }
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JOEmojiableBtn: SelectorViewDelegate {
    /**
     Function that track the user's touch, and help to find the selection user want to do.
     
     - parameter point: user's touch point
     */
    public func movedTo(_ point: CGPoint) {
        let t = options.frame.width/CGFloat(dataset.count)
        if point.y < (options.frame.minY - 50) || point.y > (information.frame.maxY + 30) {
            loseFocus()
        } else {
            if point.x - origin.x > 0 && point.x < options.frame.maxX {
                selectIndex(Int(round((point.x - origin.x) / t)))
            } else {
                loseFocus()
            }
        }
    }

    public func endTouch(_ point: CGPoint) {
        if point.x > 0 && point.x < options.frame.maxX {
            self.deActivate(selectedItem)
        } else {
            self.deActivate(-1)
        }
    }
}
