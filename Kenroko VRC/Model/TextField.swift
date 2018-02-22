//
//  TextField.swift
//  Kenroko VRC
//
//  Created by Michael Jones on 12/15/17.
//  Copyright © 2017 Kenroko. All rights reserved.
//

import UIKit

class TextField: UITextField {
    // 8
    override func caretRect(for position: UITextPosition) -> CGRect {
    return CGRect.zero
    }
    
    override func selectionRects(for range: UITextRange) -> [Any] {
    return []
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    
    if action == #selector(copy(_:)) || action == #selector(selectAll(_:)) || action == #selector(paste(_:)) {
    
    return false
    }
    
    return super.canPerformAction(action, withSender: sender)
    }
}
