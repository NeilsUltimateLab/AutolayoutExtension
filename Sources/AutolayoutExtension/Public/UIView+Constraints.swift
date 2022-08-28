//
//  UIView+Constraints.swift
//  
//
//  Created by Neil Jain on 6/25/22.
//

#if os(iOS)
import UIKit

public extension UIView {

    /// Adds the other view as a subview and constraints it with respect to parent.
    ///
    /// This functions marks the `other` view's `translatesAutoresizingMaskIntoConstraints` property to true before applying the constraints.
    ///
    /// - Parameters:
    ///   - other: A view which need to layout with respect to its parent (self).
    ///   - builder: A ``ConstraintBuilder`` to declare the NSLayoutConstraint relation between the `self` and `other` view.
    /// - Returns: A collection of ``any ConstraintType`` for the purpose of future modification.
    ///
    /// ```swift
    /// self.view.anchor(anotherView) {
    ///     EqualTo(\.leadingAnchor)
    ///     EqualTo(\.trailingAnchor)
    ///     LessThanOrEqualTo(\.safeAreaLayoutGuide.topAnchor).constant(16)
    ///     GreaterThanOrEqualTo(\.safeAreaLayoutGuide.bottomAnchor).constant(-16)
    /// }
    /// ```
    @discardableResult func anchor(_ other: UIView, @ConstraintBuilder builder: ()->[any ConstraintProvider]) -> [any ConstraintType] {
        self.addSubview(other)
        other.translatesAutoresizingMaskIntoConstraints = false
        return constraint(other, builder: builder)
    }
    
    /// Adds the constraints to `other` view with respects to its parent.
    /// - Parameters:
    ///   - other:  A view which need to layout with respect to its parent (self).
    ///   - builder: A ``ConstraintBuilder`` to declare the NSLayoutConstraint relation between the `self` and `other` view.
    /// - Returns: A collection of ``any ConstraintType`` for the purpose of future modification.
    ///
    /// Use this method in case where need to defines the constraint relation between the sibling views/layoutGuides.
    ///
    /// ```swift
    /// self.view.anchor(titleLabel) { ... }
    /// self.view.anchor(dateLabel) { ... }
    ///
    /// self.view.constraint(dateLabel) {
    ///     ...
    ///     EqualTo(\.trailingAnchor, titleLabel.leadingAnchor).constant(16)
    ///     ...
    /// }
    /// ```
    @discardableResult func constraint(_ other: UIView, @ConstraintBuilder builder: ()->[any ConstraintProvider]) -> [any ConstraintType] {
        let constraints = builder().map { provider in
            provider.constraint(self, other)
        }
        NSLayoutConstraint.activate(constraints.map{$0.constraint})
        return constraints
    }
}
#endif
