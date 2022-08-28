//
//  ConstraintProvider+Modified.swift
//  
//
//  Created by Neil Jain on 6/25/22.
//

#if os(iOS)
import UIKit

/// An extension to host some default ``ConstraintProvider``s.
public extension ConstraintProvider {
    
    /// Updates the `constants` property of `NSLayoutConstraint`.
    /// - Parameter constant: A value for constant of target constraint.
    /// This parameter does not modify the directional signs so please consider using negative signed values for appropriate layout.
    /// - Returns: ``Modified`` constraint provider.
    func constant(_ constant: CGFloat) -> some ConstraintProvider {
        Modified(provider: self) { $0.constant = constant }
    }
    
    /// Updates the `priority` of the `NSLayoutConstraint`.
    /// - Parameter priority: A `UILayoutPriority` value for the targget constraint.
    /// - Returns: ``Modified`` constraint provider
    func priority(_ priority: UILayoutPriority) -> some ConstraintProvider {
        Modified(provider: self) { $0.priority = priority }
    }
    
    /// Uses any `Hashable` id property to mark the target constraint and access it after.
    ///
    /// This is similar to `SwiftUI`'s `.id(UUID)` or `.tag("Tag")` modifier.
    /// - Parameter id: Any `Hashable` unique id.
    /// - Returns: A constraint modifier with `id` embeded.
    func id<ID: Hashable>(_ id: ID) -> some ConstraintProvider {
        Identified(id: id, provider: self)
    }
}
#endif
