//
//  ConstraintType.swift
//  
//
//  Created by Neil Jain on 6/25/22.
//

#if os(iOS)
import UIKit

/// Declares the requirement for types representing/containing `NSLayoutConstraint`.
public protocol ConstraintType {
    associatedtype Body: ConstraintType
    
    /// Any Generic ``ConstraintType`` property to store along with `NSLayoutConstraint`.
    var body: Self.Body { get }
    
    /// `NSLayoutConstraint` relation between the two views.
    var constraint: NSLayoutConstraint { get }
}
#endif
