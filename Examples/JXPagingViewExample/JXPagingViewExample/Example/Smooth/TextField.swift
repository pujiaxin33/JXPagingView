//
//  TextField.swift
//  TextField
//
//  Created by Amiee on 2021/7/22.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import UIKit

class TextField: UITextField {
    var becomeFirstResponderBlock: () -> Void = { }
    
    override func becomeFirstResponder() -> Bool {
        becomeFirstResponderBlock()
        return super.becomeFirstResponder()
    }
}
