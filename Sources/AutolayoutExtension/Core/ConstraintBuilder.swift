//
//  ConstraintBuilder.swift
//  
//
//  Created by Neil Jain on 6/25/22.
//

#if os(iOS)
import UIKit


/// A result builder for ``ConstraintProvider``.
///
/// ```swift
/// self.view.anchor(anotherView) {
///     EqualTo(\.leadingAnchor)
///     EqualTo(\.tralingAnchor).constant(-16)
/// }
/// ```
@resultBuilder public enum ConstraintBuilder {
    public typealias Component = [any ConstraintProvider]
    public typealias Expression = ConstraintProvider
    
    public static func buildBlock(_ components: Component...) -> Component {
        components.flatMap({$0})
    }
    
    public static func buildExpression(_ expression: any Expression) -> ConstraintBuilder.Component {
        [expression]
    }
    
    public static func buildOptional(_ component: ConstraintBuilder.Component?) -> ConstraintBuilder.Component {
        component?.compactMap({$0}) ?? []
    }
    
    public static func buildArray(_ components: [ConstraintBuilder.Component]) -> ConstraintBuilder.Component {
        components.flatMap{$0}
    }
    
    public static func buildEither(first component: ConstraintBuilder.Component) -> ConstraintBuilder.Component {
        component
    }
    
    public static func buildEither(second component: ConstraintBuilder.Component) -> ConstraintBuilder.Component {
        component
    }
    
    public static func buildLimitedAvailability(_ component: ConstraintBuilder.Component) -> ConstraintBuilder.Component {
        component
    }
}
#endif
