//
//  JOEmojiableBtn.swift
//  JOEmojiableBtn
//
//  Created by Jorge Raul Ovalle Zuleta on 2/28/16.
//

import UIKit

/// A type that represents the selector with options froma dataset.
open class JOEmojiableBtn: UIButton {

    /// Constants used for UI component layout.
    private enum DesignConstants {

        /// The bottom threshold area to release / cancel the selection.
        static let bottomThresholdLoseFocus: CGFloat = 50

        /// The top threshold area to release / cancel the selection.
        static let topThresholdLoseFocus: CGFloat = 30

        /// A `CGRect` that match with the screen rect.
        static let screenRect = UIScreen.main.bounds

        /// The size of the option when the expande animation start.
        static let sizeBeforeOpen: CGFloat = 10
    }

    // MARK: - Properties declaration

    @IBInspectable open weak var delegate: JOEmojiableDelegate?

    @objc open var dataset: [JOEmojiableOption]?

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
        return UILongPressGestureRecognizer(target: self,
                                            action: #selector(JOEmojiableBtn.expandOptions))
    }()

    // MARK: - View lifecycle

    /// Creates a new instace of `JOEmojiableBtn`.
    ///
    /// - Parameters:
    ///   - frame: Frame of the button will open the selector
    ///   - config: The custom configuration for the UI components.
    @objc public init(frame: CGRect, config: JOEmojiableConfig = .default) {
        self.config = config
        self.dataset = []
        super.init(frame: frame)

        addGestureRecognizer(longTap)
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

            let config = self.config
            let sizeBtn = CGSize(width: xPosition(for: dataset.count), height: config.heightForSize)
            resetUI()

            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.optionsView.frame.origin.y = self.originPoint.y - (config.spaceBetweenComponents + sizeBtn.height)
                self.optionsView.alpha = 1
            })

            for i in 0..<dataset.count {
                let optionFrame = CGRect(x: xPosition(for: i), y: sizeBtn.height * 1.2,
                                         sideSize: DesignConstants.sizeBeforeOpen)
                let option = UIImageView(frame: optionFrame)
                option.image = UIImage(named: dataset[i].image)
                option.alpha = 0.6
                optionsView.addSubview(option)
                UIView.animate(withDuration: 0.2, delay: 0.05 * Double(i), options: .curveEaseInOut,
                               animations: { () -> Void in
                    option.frame.origin.y = config.spacing
                    option.alpha = 1
                    option.frame.size = CGSize(sideSize: config.size)
                    let sizeCenter = config.size / 2
                    option.center = CGPoint(x: optionFrame.origin.x + sizeCenter,
                                            y: config.spacing + sizeCenter)
                }, completion: nil)
            }
        }
    }

    /// Function that collapse and close the Options Selector.
    private func collapseOptions() {
        guard let dataset = dataset else { fatalError("Dataset not initialized.") }

        for (i, option) in optionsView.subviews.enumerated() {
            UIView.animate(withDuration: 0.2, delay: 0.05 * Double(i), options: .curveEaseInOut,
                           animations: { () -> Void in
                self.informationView.alpha = 0
                option.alpha = 0.3
                option.frame.size = CGSize(sideSize: DesignConstants.sizeBeforeOpen)
                var yPosForOption: CGFloat = self.optionsView.frame.height + self.config.size / 2

                if let selectedItem = self.selectedItem, selectedItem == i {
                    yPosForOption = -self.optionsView.frame.height
                }

                option.center = CGPoint(x: self.xPosition(for: i) + self.config.size / 2,
                                        y: yPosForOption)
            }, completion: { (finished) -> Void in
                if finished && i == (dataset.count / 2) {
                    UIView.animate(withDuration: 0.1, animations: { () -> Void in
                        self.optionsView.alpha = 0
                        self.optionsView.frame.origin.y = self.originPoint.y - self.config.heightForSize
                    }, completion: { (finished) -> Void in
                        self.isActive = false
                        self.backgroundView.removeFromSuperview()
                        if let selectedItem = self.selectedItem {
                            self.delegate?.selectedOption(self, index: selectedItem)
                        } else {
                            self.delegate?.cancelledAction(self)
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
            let sizeBtn = CGSize(width: self.xPosition(for: dataset.count),
                                 height: config.heightForSize)
            let originOptionView = CGPoint(x: self.originPoint.x, y: self.originPoint.y - (config.spaceBetweenComponents + sizeBtn.height))
            self.optionsView.frame = CGRect(origin: originOptionView, size: sizeBtn)
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
                let sizeBtn = CGSize(width: previousOption * (config.spacing + config.minSize) + config.maxSize, height: config.heightForMinSize)
                self.optionsView.frame = CGRect(origin: CGPoint(x: self.originPoint.x, y: self.originPoint.y - (config.spaceBetweenComponents + sizeBtn.height)),
                                                size: sizeBtn)
                self.optionsView.layer.cornerRadius = sizeBtn.height / 2
                var last: CGFloat = index != 0 ? config.spacing : 0

                let minSizeCenter = config.minSize / 2
                let centerYForOption = minSizeCenter + config.spacing

                for (idx, view) in self.optionsView.subviews.enumerated() {
                    view.frame = CGRect(x: last, y: config.spacing, sideSize: config.minSize)
                    switch idx {
                    case (index-1):
                        view.center.y = minSizeCenter
                        last += config.minSize
                    case index:
                        view.frame = CGRect(x: last, y: -(config.maxSize/2), sideSize: config.maxSize)
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

    /// Reset the UI to the initial state.
    private func resetUI() {
        guard let dataset = dataset else { fatalError("Dataset not initialized.") }

        originPoint = superview?.convert(frame.origin, to: nil) ?? .zero

        if originPoint != frame.origin {
            backgroundView.frame.origin.x -= originPoint.x
            backgroundView.frame.origin.y -= originPoint.y
        }

        superview?.addSubview(backgroundView)

        informationView = InformationView(frame: CGRect(x: 0, y: originPoint.y, width: DesignConstants.screenRect.width, height: frame.height))
        informationView.backgroundColor = .white
        backgroundView.addSubview(informationView)

        let optionsViewSize = CGSize(width: xPosition(for: dataset.count), height: config.heightForSize)
        let optionsViewOrigin = CGPoint(x: originPoint.x, y: originPoint.y - optionsViewSize.height)
        optionsView = UIView(frame: CGRect(origin: optionsViewOrigin, size: optionsViewSize))
        optionsView.layer.cornerRadius  = optionsView.frame.height / 2
        optionsView.backgroundColor     = .white
        optionsView.layer.shadowColor   = UIColor.lightGray.cgColor
        optionsView.layer.shadowOffset  = .zero
        optionsView.layer.shadowOpacity = 0.5
        optionsView.alpha               = 0.3
        backgroundView.addSubview(optionsView)
    }
}

// MARK: - SelectorViewDelegate
extension JOEmojiableBtn: SelectorViewDelegate {

    public func movedTo(_ point: CGPoint) {
        guard let dataset = dataset else { fatalError("Dataset not initialized.") }
        let relativeSizePerOption = optionsView.frame.width / CGFloat(dataset.count)

        // Check if the point's position is inside the defined area.
        if point.y < (optionsView.frame.minY - DesignConstants.bottomThresholdLoseFocus) || point.y > (informationView.frame.maxY + DesignConstants.topThresholdLoseFocus) {
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
