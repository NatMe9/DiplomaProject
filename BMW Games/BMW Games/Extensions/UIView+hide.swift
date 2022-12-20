//
//  UIView+hide.swift
//  BMW Games
//
//  Created by Natalia Givojno on 17.12.22.
//

import UIKit

extension UIView {
    
    func hide() {
        guard !isHidden else { return }
        isHidden = true
    }
    
    func show() {
        guard isHidden else { return }
        isHidden = false
    }
}
