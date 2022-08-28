//
//  ConstraintProvider.swift
//  
//
//  Created by Neil Jain on 6/25/22.
//

#if os(iOS)
import UIKit

/// A protocol to build the ``ConstraintBuilder``.
public protocol ConstraintProvider {
    associatedtype Constraint: ConstraintType
    
    /// Defines the layout constraint relation between parent and child view.
    /// - Parameters:
    ///   - parent: A  view as a parent.
    ///   - child: A view as a child. Parent view will add the child as a subview.
    /// - Returns: A ``Constraint`` relation ship between parent and child.
    func constraint(_ parent: UIView, _ child: UIView) -> Constraint
}
#endif
