//
//  Identified.swift
//  
//
//  Created by Neil Jain on 6/25/22.
//

#if os(iOS)
import UIKit

/// A ConstraintType for hosting any `Generic`, `Hashable` ID along with `NSLayoutConstraint`.
struct IDConstraint<ID: Hashable>: ConstraintType, Identifiable {
    var body: ID
    var constraint: NSLayoutConstraint
    
    var id: ID {
        self.body
    }
}

/// A ConstraintModifier to store any `Hashable` ID along with previous constraint relations.
public struct Identified<Provider, ID: Hashable>: ConstraintModifier where Provider: ConstraintProvider {
    var id: ID
    public var provider: Provider
    
    init(id: ID, provider: Provider) {
        self.id = id
        self.provider = provider
    }
    
    public func constraint(_ parent: UIView, _ child: UIView) -> some ConstraintType {
        let constraints = provider.constraint(parent, child).constraint
        return IDConstraint(body: id, constraint: constraints)
    }
}
#endif
