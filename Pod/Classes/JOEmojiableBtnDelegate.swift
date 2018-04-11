//
//  JOEmojiableBtnDelegate.swift
//  JOEmojiableBtn
//
//  Created by Jorge R Ovalle Z on 4/11/18.
//  Copyright © 2018 Jorge Ovalle. All rights reserved.
//

import Foundation

/// <#Description#>
public protocol JOEmojiableDelegate: class {
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - sender: <#sender description#>
    ///   - index: <#index description#>
    func selectedOption(_ sender: JOEmojiableBtn, index: Int)
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    func singleTap(_ sender: JOEmojiableBtn)
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    func cancelledAction(_ sender: JOEmojiableBtn)
}

