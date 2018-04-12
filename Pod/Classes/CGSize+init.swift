//
//  CGSize+init.swift
//  JOEmojiableBtn
//
//  Created by Jorge R Ovalle Z on 4/7/18.
//  Copyright © 2018 Jorge Ovalle. All rights reserved.
//

import Foundation

extension CGSize {

    /// Creates an instance of `CGSize` with the same width and height.
    ///
    /// - Parameter sideSize: Size of the side.
    init(sideSize: CGFloat) {
        self.init(width: sideSize, height: sideSize)
    }
}
