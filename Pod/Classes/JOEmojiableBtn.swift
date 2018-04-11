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
    
    /// Constants used for UI component layout.
    private enum DesignConstants {
        
        /// <#Description#>
        static let leftThresholdLoseFocus: CGFloat = 50
        
        /// <#Description#>
        static let rightThresholdLoseFocus: CGFloat = 30
        
        /// <#Description#>
        static let screenRect = UIScreen.main.bounds
        
        static let sizeBeforeOpen: CGFloat = 10
    }
    
    // MARK: - Properties declaration
    
    open weak var delegate: JOEmojiableDelegate?
    
    open var dataset: [JOEmojiableOption]?

    private var isActive: Bool = false
    public private (set) var selectedItem: Int?
    private var originPoint: CGPoint = .zero
    
    private lazy var backgroundView: SelectorView = {
        let backgroundView = SelectorView(frame: DesignConstants.screenRect)
        backgroundView.delegate = self
        backgroundView.backgroundColor = .clear
        return backgroundView
    }()
    private var informationView: InformationView!
    private var optionsView: UIView!

    private let config: JOEmojiableConfig
    
    // MARK: - Events declaration
    
    private lazy var longTap: UILongPressGestureRecognizer = {
        return UILongPressGestureRecognizer(target: self, action: #selector(JOEmojiableBtn.expandOptions))
    }()
    
    private lazy var singleTap: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(JOEmojiableBtn.expandOptions))
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
    
    /// Function that open and expand the Options Selector.
    @objc private func expandOptions() {
        if !isActive {
            guard let dataset = dataset else { fatalError("Dataset not initialized.") }
            selectedItem = nil
            isActive = true
            
            originPoint = superview?.convert(frame.origin, to: nil) ?? .zero

            if originPoint != frame.origin {
                backgroundView.frame.origin.x -= originPoint.x
                backgroundView.frame.origin.y -= originPoint.y
            }

            superview?.addSubview(backgroundView)
            
            informationView = InformationView(frame: CGRect(x: 0, y: originPoint.y, width: DesignConstants.screenRect.width, height: frame.height))
            informationView.backgroundColor = .white
            backgroundView.addSubview(informationView)
            
            let config = self.config
            let sizeBtn = CGSize(width: xPosition(for: dataset.count), height: config.size + 2 * config.spacing)
            optionsView = UIView(frame: CGRect(x: originPoint.x, y: originPoint.y - sizeBtn.height, width: sizeBtn.width, height: sizeBtn.height))
            optionsView.layer.cornerRadius  = optionsView.frame.height / 2
            optionsView.backgroundColor     = .white
            optionsView.layer.shadowColor   = UIColor.lightGray.cgColor
            optionsView.layer.shadowOffset  = .zero
            optionsView.layer.shadowOpacity = 0.5
            optionsView.alpha               = 0.3
            backgroundView.addSubview(optionsView)
            
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.optionsView.frame.origin.y = self.originPoint.y - (config.spaceBetweenComponents + sizeBtn.height)
                self.optionsView.alpha = 1
            })

            for i in 0..<dataset.count {
                let imageFrame = CGRect(x: xPosition(for: i), y: sizeBtn.height * 1.2, sideSize: DesignConstants.sizeBeforeOpen)
                let option = UIImageView(frame: imageFrame)
                option.image = UIImage(named: dataset[i].image)
                option.alpha = 0.6
                optionsView.addSubview(option)
                UIView.animate(withDuration: 0.2, delay: 0.05 * Double(i), options: .curveEaseInOut, animations: { () -> Void in
                    option.frame.origin.y = config.spacing
                    option.alpha = 1
                    option.frame.size = CGSize(sideSize: config.size)
                    option.center = CGPoint(x: imageFrame.origin.x + config.size / 2, y: config.spacing + config.size / 2)
                }, completion: nil)
            }

            
        }
    }

    /// Function that collapse and close the Options Selector
    private func collapseOptions() {
        guard let dataset = dataset else { fatalError("Dataset not initialized.") }
        
        let selectedItem = self.selectedItem ?? -1
        
        for (i, option) in optionsView.subviews.enumerated() {
            UIView.animate(withDuration: 0.2, delay: 0.05 * Double(i), options: .curveEaseInOut, animations: { () -> Void in
                self.informationView.alpha = 0
                option.alpha = 0.3
                option.frame.size = CGSize(sideSize: DesignConstants.sizeBeforeOpen)
                let yPosForOption: CGFloat = (selectedItem == i ? -self.optionsView.frame.height : self.optionsView.frame.height) + self.config.size / 2
                
                option.center = CGPoint(x: self.xPosition(for: i) + self.config.size / 2, y: yPosForOption)
            }, completion: { (finished) -> Void in
                if finished && i == (dataset.count / 2) {
                    UIView.animate(withDuration: 0.1, animations: { () -> Void in
                        self.optionsView.alpha = 0
                        self.optionsView.frame.origin.y = self.originPoint.y - self.config.size + 2 * self.config.spacing
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

    /// A function intended to animate the selector and the options,
    /// in case the user is not focusing a specific option.
    private func loseFocusFromOptions() {
        guard let dataset = dataset else { fatalError("Dataset not initialized.") }
        selectedItem = nil
        informationView.show()
        let config = self.config
        UIView.animate(withDuration: 0.3) { () -> Void in
            let sizeBtn = CGSize(width: self.xPosition(for: dataset.count), height: config.size + 2 * config.spacing)
            self.optionsView.frame = CGRect(origin: CGPoint(x: self.originPoint.x, y: self.originPoint.y - (config.spaceBetweenComponents + sizeBtn.height)), size: sizeBtn)
            self.optionsView.layer.cornerRadius = sizeBtn.height / 2
            for (idx, view) in self.optionsView.subviews.enumerated() {
                view.frame = CGRect(x: self.xPosition(for: idx), y: config.spacing, sideSize: config.size)
            }
        }
    }

    /// When a user in focusing an option, that option should magnify.
    ///
    /// - Parameter index: The index of the option in the dataset.
    private func focusOption(withIndex index: Int) {
        guard let dataset = dataset else { fatalError("Dataset not initialized.") }
        
        if index >= 0 && index < dataset.count {
            selectedItem = index
            informationView.hide()
            let config = self.config
            UIView.animate(withDuration: 0.3) { () -> Void in
                let previousOption = CGFloat(dataset.count - 1)
                let sizeBtn = CGSize(width: previousOption * (config.spacing + config.minSize) + config.maxSize, height: config.minSize + 2 * config.spacing)
                self.optionsView.frame = CGRect(origin: CGPoint(x: self.originPoint.x, y: self.originPoint.y - (config.spaceBetweenComponents + sizeBtn.height)),
                                            size: sizeBtn)
                self.optionsView.layer.cornerRadius = sizeBtn.height / 2
                var last: CGFloat = index != 0 ? config.spacing : 0
                
                let centerYForMinSize = config.minSize / 2
                let centerYForOption = centerYForMinSize + config.spacing
                
                for (idx, view) in self.optionsView.subviews.enumerated() {
                    view.frame = CGRect(x: last, y: config.spacing, sideSize: config.minSize)
                    switch idx {
                    case (index-1):
                        view.center.y = centerYForOption
                        last += config.minSize
                    case index:
                        view.frame = CGRect(x: last, y: -centerYForMinSize, sideSize: config.maxSize)
                        last += config.maxSize
                    default:
                        view.center.y = centerYForOption
                        last += config.minSize + config.spacing
                    }
                }
            }
        }
    }
    
    /// Calculate the `x` position for a given dataset option.
    ///
    /// - Parameter option: the position of the option in the dataset. <0... dataset.count>.
    /// - Returns: The x position for a given option.
    private func xPosition(for option: Int) -> CGFloat {
        let option = CGFloat(option)
        return (option + 1) * config.spacing + config.size * option
    }
}

// MARK: - SelectorViewDelegate
extension JOEmojiableBtn: SelectorViewDelegate {
    
    public func movedTo(_ point: CGPoint) {
        guard let dataset = dataset else { fatalError("Dataset not initialized.") }

        let relativeSizePerOption = optionsView.frame.width / CGFloat(dataset.count)
        if point.y < (optionsView.frame.minY - DesignConstants.leftThresholdLoseFocus) || point.y > (informationView.frame.maxY + DesignConstants.rightThresholdLoseFocus) {
            loseFocusFromOptions()
        } else {
            if point.x - originPoint.x > 0 && point.x < optionsView.frame.maxX {
                focusOption(withIndex: Int(round((point.x - originPoint.x) / relativeSizePerOption)))
            } else {
                loseFocusFromOptions()
            }
        }
    }

    public func endTouch(_ point: CGPoint) {
        collapseOptions()
    }
}
