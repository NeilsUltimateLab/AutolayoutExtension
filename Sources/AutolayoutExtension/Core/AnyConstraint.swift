//
//  AnyConstraint.swift
//  
//
//  Created by Neil Jain on 6/25/22.
//

#if os(iOS)
import UIKit

/// A Type erased ``ConstraintType`` for easy use.
struct AnyConstraint: ConstraintType {
    var constraint: NSLayoutConstraint
    
    init(_ constraint: NSLayoutConstraint) {
        self.constraint = constraint
    }
}
#endif
