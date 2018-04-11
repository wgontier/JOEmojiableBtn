//
//  JOEmojiableBtn.swift
//  JOEmojiableBtn
//
//  Created by Jorge Raul Ovalle Zuleta on 2/28/16.
//  Copyright © 2018 Jorge Ovalle. All rights reserved.
//

import UIKit

/// <#Description#>
open class JOEmojiableBtn: UIButton {
    
    private enum DesignConstants {
        
        /// <#Description#>
        static var leftThresholdLoseFocus: CGFloat = 50
        
        /// <#Description#>
        static var rightThresholdLoseFocus: CGFloat = 30
        
        /// <#Description#>
        static var screenRect = UIScreen.main.bounds
    }
    
    // MARK: - Properties declaration
    
    open weak var delegate: JOEmojiableDelegate?
    
    open var dataset: [JOEmojiableOption]?

    private var isActive: Bool = false
    public private (set) var selectedItem: Int?
    
    private var backgroundView: SelectorView!
    private var options: UIView!
    private var origin: CGPoint = .zero

    private var informationView: InformationView!

    private let config: JOEmojiableConfig
    
    // MARK: - Events declaration
    
    private lazy var longTap: UILongPressGestureRecognizer = {
        return UILongPressGestureRecognizer(target: self, action: #selector(JOEmojiableBtn.showOptionsSelector))
    }()
    
    private lazy var singleTap: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(JOEmojiableBtn.showOptionsSelector))
    }()

    // MARK: - View lifecycle
    
    /// Creates a new instace of `JOEmojiableBtn`.
    ///
    /// - Parameters:
    ///   - frame: Frame of the button will open the selector
    ///   - config: The custom configuration for the UI components.
    public init(frame: CGRect, config: JOEmojiableConfig = .default) {
        self.config = config
        self.dataset = []
        super.init(frame: frame)

        addGestureRecognizer(longTap)
        addGestureRecognizer(singleTap)
        layer.masksToBounds = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Visual component interaction / animation
    
    /// Function that open the Options Selector
    @objc private func showOptionsSelector() {
        if !isActive {
            guard let dataset = dataset else { fatalError("Dataset not initialized.") }
            selectedItem = nil
            isActive = true
            backgroundView = SelectorView(frame: DesignConstants.screenRect)
            backgroundView.delegate = self
            backgroundView.backgroundColor = .clear

            origin = superview?.convert(frame.origin, to: nil) ?? .zero

            if origin != frame.origin {
                backgroundView.frame.origin.x -= origin.x
                backgroundView.frame.origin.y -= origin.y
            }

            superview?.addSubview(backgroundView)
            
            informationView = InformationView(frame: CGRect(x: 0, y: origin.y, width: DesignConstants.screenRect.width, height: frame.height))
            informationView.backgroundColor = .white
            backgroundView.addSubview(informationView)
            
            let config = self.config
            let optionsCount = CGFloat(dataset.count)
            let sizeBtn = CGSize(width: (optionsCount + 1) * config.spacing + config.size * optionsCount, height: config.size + 2 * config.spacing)
            options = UIView(frame: CGRect(x: origin.x, y: origin.y - sizeBtn.height, width: sizeBtn.width, height: sizeBtn.height))
            options.layer.cornerRadius  = options.frame.height / 2
            options.backgroundColor     = .white
            options.layer.shadowColor   = UIColor.lightGray.cgColor
            options.layer.shadowOffset  = .zero
            options.layer.shadowOpacity = 0.5
            options.alpha               = 0.3
            backgroundView.addSubview(options)
            
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.options.frame.origin.y = self.origin.y - (config.spaceBetweenComponents + sizeBtn.height)
                self.options.alpha = 1
            })

            for i in 0..<dataset.count {
                let iFloat = CGFloat(i)
                let imageFrame = CGRect(x: (iFloat + 1) * config.spacing + config.size * iFloat, y: sizeBtn.height * 1.2, sideSize: 10)

                let option = UIImageView(frame: imageFrame)
                option.image = UIImage(named: dataset[i].image)
                option.alpha = 0.6
                options.addSubview(option)
                UIView.animate(withDuration: 0.2, delay: 0.05 * Double(i), options: .curveEaseInOut, animations: { () -> Void in
                    option.frame.origin.y = config.spacing
                    option.alpha = 1
                    option.frame.size = CGSize(sideSize: config.size)
                    option.center = CGPoint(x: imageFrame.origin.x + config.size / 2, y: config.spacing + config.size / 2)
                }, completion: nil)
            }

            
        }
    }

    /// Function that close the Options Selector
    private func deActivate() {
        guard let dataset = dataset else { fatalError("Dataset not initialized.") }
        
        let selectedItem = self.selectedItem ?? -1
        
        for (i, option) in options.subviews.enumerated() {
            UIView.animate(withDuration: 0.2, delay: 0.05 * Double(i), options: .curveEaseInOut, animations: { () -> Void in
                self.informationView.alpha = 0
                option.alpha = 0.3
                option.frame.size = CGSize(sideSize: 10)
            
                let yPosForOption: CGFloat = (selectedItem == i ? -self.options.frame.height : self.options.frame.height) + self.config.size / 2
                
                option.center = CGPoint(x: (CGFloat(i + 1) * self.config.spacing) + (self.config.size * CGFloat(i)) + self.config.size / 2, y: yPosForOption)
            }, completion: { (finished) -> Void in
                if finished && i == (dataset.count / 2) {
                    UIView.animate(withDuration: 0.1, animations: { () -> Void in
                        self.options.alpha = 0
                        self.options.frame.origin.y = self.origin.y - (self.config.size + (2 * self.config.spacing))
                    }, completion: { (finished) -> Void in
                        self.isActive = false
                        self.backgroundView.removeFromSuperview()
                        if selectedItem < 0 {
                            self.delegate?.cancelledAction(self)
                        } else {
                            self.delegate?.selectedOption(self, index: selectedItem)
                        }
                    })
                }
            })
        }
    }

    private func loseFocusFromOptions() {
        guard let dataset = dataset else { fatalError("Dataset not initialized.") }
        selectedItem = nil
        informationView.show()
        let config = self.config
        UIView.animate(withDuration: 0.3) { () -> Void in
            let optionsCount = CGFloat(dataset.count)
            let sizeBtn = CGSize(width: (optionsCount + 1) * config.spacing + config.size * optionsCount, height: config.size + 2 * config.spacing)
            self.options.frame = CGRect(origin: CGPoint(x: self.origin.x, y: self.origin.y - (config.spaceBetweenComponents + sizeBtn.height)), size: sizeBtn)
            self.options.layer.cornerRadius = sizeBtn.height / 2
            for (idx, view) in self.options.subviews.enumerated() {
                let index = CGFloat(idx)
                view.frame = CGRect(x: (index + 1) * config.spacing + config.size * index, y: config.spacing, sideSize: config.size)
            }
        }
    }

    private func focusOption(withIndex index: Int) {
        guard let dataset = dataset else { fatalError("Dataset not initialized.") }
        
        if index >= 0 && index < dataset.count {
            selectedItem = index
            informationView.hide()
            let config = self.config
            UIView.animate(withDuration: 0.3) { () -> Void in
                let optionsCountMinusOne = CGFloat(dataset.count - 1)
                let sizeBtn = CGSize(width: optionsCountMinusOne * (config.spacing + config.minSize) + config.maxSize, height: config.minSize + 2 * config.spacing)
                self.options.frame = CGRect(origin: CGPoint(x: self.origin.x, y: self.origin.y - (config.spaceBetweenComponents + sizeBtn.height)),
                                            size: sizeBtn)
                self.options.layer.cornerRadius = sizeBtn.height / 2
                var last: CGFloat = index != 0 ? config.spacing : 0
                
                let halfMaxSize = config.minSize / 2
                let centerYForOption = halfMaxSize + config.spacing
                
                for (idx, view) in self.options.subviews.enumerated() {
                    view.frame = CGRect(x: last, y: config.spacing, sideSize: config.minSize)
                    switch idx {
                    case (index-1):
                        view.center.y = centerYForOption
                        last += config.minSize
                    case index:
                        view.frame = CGRect(x: last, y: -halfMaxSize, width: config.maxSize, height: config.maxSize)
                        last += config.maxSize
                    default:
                        view.center.y = centerYForOption
                        last += config.minSize + config.spacing
                    }
                }
            }
        }
    }
}

// MARK: - SelectorViewDelegate
extension JOEmojiableBtn: SelectorViewDelegate {
    
    public func movedTo(_ point: CGPoint) {
        guard let dataset = dataset else { fatalError("Dataset not initialized.") }

        let relativeSizePerOption = options.frame.width / CGFloat(dataset.count)
        if point.y < (options.frame.minY - DesignConstants.leftThresholdLoseFocus) || point.y > (informationView.frame.maxY + DesignConstants.rightThresholdLoseFocus) {
            loseFocusFromOptions()
        } else {
            if point.x - origin.x > 0 && point.x < options.frame.maxX {
                focusOption(withIndex: Int(round((point.x - origin.x) / relativeSizePerOption)))
            } else {
                loseFocusFromOptions()
            }
        }
    }

    public func endTouch(_ point: CGPoint) {
        deActivate()
    }
}
