//
//  GreaterThanOrEqualTo.swift
//  
//
//  Created by Neil Jain on 6/25/22.
//

#if os(iOS)
import UIKit

/// A Greater than or equal to relation between the two views.
///
/// This excepts the argments as a `KeyPath` for parent and child `UIView`.
///
/// This is equivalent to `.constraint(greaterThanOrEqualTo:)` method defined on `NSLayoutAnchor`.
///
/// - Usage: 
/// ```swift
/// self.view.anchor(anotherView) {
///     GreaterThanOrEqualTo(\.leadingAnchor)
///     GreaterThanOrEqualTo(\.trailingAnchor, titleLabel.leadingAnchor)
/// }
/// ```
public struct GreaterThanOrEqualTo<L, Axis>: ConstraintProvider where L: NSLayoutAnchor<Axis> {
    let from: KeyPath<UIView, L>
    let toKeyPath: KeyPath<UIView, L>
    var siblingLayoutAnchor: L?
    
    /// Takes `KeyPath<UIView, NSLayoutAnchor<Axis>>`.
    /// - Parameters:
    ///   - from: `KeyPath` from Parent `UIView`'s NSLayoutAnchor properties.
    ///   - toKeyPath: `KeyPath` from child `UIView`'s NSLayoutAnchor properties.
    public init(_ from: KeyPath<UIView, L>, _ toKeyPath: KeyPath<UIView, L>) {
        self.from = from
        self.toKeyPath = toKeyPath
    }
    
    /// Takes single `KeyPath` for both parent and child view.
    /// - Parameter keyPath: `KeyPath` from Parent/Child view's NSLayoutAnchor properties.
    ///
    /// This is useful when need to directly constraint child view's anchor to parent.
    ///
    /// This is equivalent to this code, where both anchors for parent and child are same.
    /// ```swift
    /// self.label.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor)
    /// ```
    public init(_ keyPath: KeyPath<UIView, L>) {
        from = keyPath
        toKeyPath = keyPath
    }
    
    /// Initialiser for ``GreaterThanOrEqualTo`` where `KeyPath` for parent is accessible with other sibling view's anchor properties.
    /// - Parameters:
    ///   - keyPath: `KeyPath` from Parent `UIView`'s NSLayoutAnchor properties.
    ///   - siblingLayoutAnchor: A `UILayoutAnchor` for other sibling view.
    ///
    /// For example.
    ///   ```swift
    ///   self.view.anchor(dateLabel) {
    ///     GreaterThanOrEqualTo(\.centerYAnchor, titleLabel.centerYAnchor)
    ///   }
    ///   ```
    public init(_ keyPath: KeyPath<UIView, L>, _ siblingLayoutAnchor: L?) {
        from = keyPath
        toKeyPath = keyPath
        self.siblingLayoutAnchor = siblingLayoutAnchor
    }
    
    public func constraint(_ parent: UIView, _ child: UIView) -> some ConstraintType {
        let constraint = child[keyPath: from].constraint(greaterThanOrEqualTo: siblingLayoutAnchor ?? parent[keyPath: toKeyPath])
        return AnyConstraint(constraint)
    }
}

/// An ``GreaterThanOrEqualTo`` varient where the `KeyPath` leads to properties of `NSLayoutDimension` class.
///
/// This is equivalent to `.constraint(greaterThanOrEqualToConstant:)` declared on `NSLayoutDimension`.
public struct GreaterThanOrEqualToConstant<L>: ConstraintProvider where L: NSLayoutDimension {
    let keyPath: KeyPath<UIView, L>
    let constant: CGFloat
    
    /// Initialiser takes KeyPath for the child's `NSLayoutDimension` properties.
    /// - Parameters:
    ///   - keyPath: KeyPath` from Parent `UIView`'s NSLayoutAnchor properties.
    ///   - constant: `NSLayoutDimension` requires a constant value.
    ///
    ///   For example.
    ///   ```swift
    ///   self.view.anchor(dateLabel) {
    ///     EqualToConstant(\.widthAnchor, constant: 120)
    ///   }
    ///   ```
    public init(_ keyPath: KeyPath<UIView, L>, constant: CGFloat) {
        self.keyPath = keyPath
        self.constant = constant
    }
    
    public func constraint(_: UIView, _ child: UIView) -> some ConstraintType {
        let constraint = child[keyPath: keyPath].constraint(greaterThanOrEqualToConstant: constant)
        return AnyConstraint(constraint)
    }
}
#endif
