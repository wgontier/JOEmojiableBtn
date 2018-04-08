//
//  InformationView.swift
//  JOEmojiableBtn
//
//  Created by Jorge R Ovalle Z on 4/6/18.
//  Copyright © 2018 Jorge Ovalle. All rights reserved.
//

import UIKit

open class InformationView: UIView {
    
    private enum DesignConstants {
        static let lineColor = UIColor(red: 0.8, green: 0.81, blue: 0.82, alpha: 1)
        static let textColor = UIColor(red: 0.57, green: 0.59, blue: 0.64, alpha: 1)
    }
    
    fileprivate var textInformation: UILabel!
    
    open override func draw(_ rect: CGRect) {
       
        textInformation = UILabel(frame: .zero)
        textInformation.backgroundColor = .white
        textInformation.textColor = DesignConstants.textColor
        textInformation.text = "Release to Cancel"
        textInformation.textAlignment = .center
        textInformation.font = UIFont.boldSystemFont(ofSize: 12)
        textInformation.alpha = 0
        addSubview(textInformation)
        
        func createLine(from: CGPoint, to: CGPoint) {
            let line = UIBezierPath()
            line.move(to: from)
            line.addLine(to: to)
            DesignConstants.lineColor.setStroke()
            line.lineWidth = 1
            line.stroke()
        }
        
        let dots = UIBezierPath()
        dots.move(to: CGPoint(x: 18.5, y: (rect.height / 2)))
        dots.addLine(to: CGPoint(x: rect.width, y: (rect.height/2)))
        dots.lineCapStyle = .round
        DesignConstants.lineColor.setStroke()
        dots.lineWidth = 3
        let dashes: [CGFloat] = [dots.lineWidth * 0, 37]
        dots.setLineDash(dashes, count: dashes.count, phase: 0)
        dots.stroke()
        
        createLine(from: .zero, to: CGPoint(x: rect.width, y: 0))
        createLine(from: CGPoint(x: 0, y: rect.height), to: CGPoint(x: rect.width, y: rect.height))
        
    }
    
    func activateInformationView(_ active: Bool) {
        textInformation.alpha = active ? 1 : 0
    }
}


