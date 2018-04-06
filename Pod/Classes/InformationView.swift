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
    }
    
    fileprivate var textInformation: UILabel!
    
    open override func draw(_ rect: CGRect) {
        let dots = UIBezierPath()
        dots.move(to: CGPoint(x: 18.5, y: (rect.height/2)))
        dots.addLine(to: CGPoint(x: rect.width, y: (rect.height/2)))
        dots.lineCapStyle = CGLineCap.round
        DesignConstants.lineColor.setStroke()
        dots.lineWidth = 3
        let dashes: [CGFloat] = [dots.lineWidth * 0, 37]
        dots.setLineDash(dashes, count: dashes.count, phase: 0)
        dots.stroke()
        
        let lineSuperior = UIBezierPath()
        lineSuperior.move(to: CGPoint(x: 0, y: 0))
        lineSuperior.addLine(to: CGPoint(x: rect.width, y: 0))
        DesignConstants.lineColor.setStroke()
        lineSuperior.lineWidth = 1
        lineSuperior.stroke()
        
        let lineInferior = UIBezierPath()
        lineInferior.move(to: CGPoint(x: 0, y: rect.height))
        lineInferior.addLine(to: CGPoint(x: rect.width, y: rect.height))
        DesignConstants.lineColor.setStroke()
        lineInferior.lineWidth = 1
        lineInferior.stroke()
        
        textInformation = UILabel(frame: CGRect(x: 0, y: 1, width: rect.width, height: rect.height-2))
        textInformation.backgroundColor = UIColor.white
        textInformation.textColor = UIColor(red: 0.57, green: 0.59, blue: 0.64, alpha: 1)
        textInformation.text = "Release to Cancel"
        textInformation.textAlignment = .center
        textInformation.font = UIFont.boldSystemFont(ofSize: 12)
        textInformation.alpha = 0
        addSubview(textInformation)
    }
    
    func activateInfo(_ active: Bool) {
        textInformation.alpha = active ? 1 : 0
    }
}


