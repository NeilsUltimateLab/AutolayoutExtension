//
//  EqualTo.swift
//  
//
//  Created by Neil Jain on 6/25/22.
//

#if os(iOS)
import UIKit

/// A Equal relation between the two views.
///
/// This excepts the argments as a `KeyPath` for parent and child `UIView`.
///
/// This is equivalent to `.constraint(equalTo:)` method defined on `NSLayoutAnchor`.
///
///
/// - Usage:
/// ```swift
/// self.view.anchor(anotherView) {
///     EqualTo(\.leadingAnchor)
///     EqualTo(\.trailingAnchor, titleLabel.leadingAnchor)
/// }
/// ```
public struct EqualTo<L, Axis>: ConstraintProvider where L: NSLayoutAnchor<Axis> {
    
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
    /// self.label.leadingAnchor.constraint(equalTo: view.leadingAnchor)
    /// ```
    public init(_ keyPath: KeyPath<UIView, L>) {
        from = keyPath
        toKeyPath = keyPath
    }
    
    /// Initialiser for ``EqualTo`` where `KeyPath` for parent is accessible with other sibling view's anchor properties.
    /// - Parameters:
    ///   - keyPath: `KeyPath` from Parent `UIView`'s NSLayoutAnchor properties.
    ///   - siblingLayoutAnchor: A `UILayoutAnchor` for other sibling view.
    ///
    /// For example.
    ///   ```swift
    ///   self.view.anchor(dateLabel) {
    ///     EqualTo(\.centerYAnchor, titleLabel.centerYAnchor)
    ///   }
    ///   ```
    public init(_ keyPath: KeyPath<UIView, L>, with siblingLayoutAnchor: L?) {
        from = keyPath
        toKeyPath = keyPath
        self.siblingLayoutAnchor = siblingLayoutAnchor
    }
    
    public func constraint(_ parent: UIView, _ child: UIView) -> some ConstraintType {
        let constraint = child[keyPath: from].constraint(equalTo: siblingLayoutAnchor ?? parent[keyPath: toKeyPath])
        return AnyConstraint(constraint)
    }
}

/// An ``EqualTo`` varient where the `KeyPath` leads to properties of `NSLayoutDimension` class.
///
/// This is equivalent to `.constraint(equalToConstant:)` declared on `NSLayoutDimension`.
///
/// ```swift
/// self.view.anchor(dateLabel) {
///   EqualToConstant(\.widthAnchor, constant: 120)
/// }
///   ```
public struct EqualToConstant<L>: ConstraintProvider where L: NSLayoutDimension {
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
        let constraint = child[keyPath: keyPath].constraint(equalToConstant: constant)
        return AnyConstraint(constraint)
    }
}
#endif
