//
//  Modified.swift
//  
//
//  Created by Neil Jain on 6/25/22.
//

#if os(iOS)
import UIKit

/// A ``ConstraintModifier`` provides an interface to modify the properties of `NSLayoutConstraint`.
///
/// Couple of use cases of this are ``priority(_:)`` and ``constant(_:)``.
public struct Modified<Provider>: ConstraintModifier where Provider: ConstraintProvider {
    var modifying: (NSLayoutConstraint)->Void
    public var provider: Provider
    
    /// Initialises using the previous ``ConstraintProvider`` and a modifying closure to `NSLayoutConstraint`.
    /// - Parameters:
    ///   - provider: Previous Provider to get the constraint relation from ``ConstraintProvider``.
    ///   - modifying: A closure to modify the defined `NSLayoutConstraint` relation.
    public init(provider: Provider, _ modifying: @escaping (NSLayoutConstraint)->Void) {
        self.modifying = modifying
        self.provider = provider
    }
    
    /// Protocol conformance method to be ``ConstraintProvider``.
    ///
    /// This method invokes the previous `NSLayoutConstraint` relation defined by `provider` and apply the `modifying` closure on it.
    /// - Parameters:
    ///   - parent: A view as a Parent.
    ///   - child: A view as a child.
    /// - Returns: A type erased ``ConstraintType``.
    public func constraint(_ parent: UIView, _ child: UIView) -> some ConstraintType {
        let constraints = provider.constraint(parent, child)
        modifying(constraints.constraint)
        return constraints
    }
}
#endif
