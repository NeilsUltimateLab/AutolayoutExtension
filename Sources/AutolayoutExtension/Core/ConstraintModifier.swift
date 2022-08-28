//
//  ConstraintModifier.swift
//  
//
//  Created by Neil Jain on 6/25/22.
//

#if os(iOS)
import UIKit

/// A Protocol to provide a modifier to ``ConstraintProvider``.
///
/// This can be used to generate SwiftUI style modifiers.
///
/// **Example**:
/// ```swift
/// EqualTo(\.leadingAnchor).constant(16)
/// EqualTo(\.heightAnchor).id(UUID())
/// ```
///
/// Visit ``ConstraintProvider/constant(_:)`` and ``ConstraintProvider/id(_:)`` for usage example.
public protocol ConstraintModifier: ConstraintProvider {
    associatedtype Provider = ConstraintProvider
    var provider: Self.Provider { get set }
}
#endif
