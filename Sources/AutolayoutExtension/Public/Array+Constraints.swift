//
//  Array+Constraints.swift
//  
//
//  Created by Neil Jain on 6/25/22.
//
#if os(iOS)
import UIKit

/// An helper extension over any ``ConstraintType`` collection to extract an ID.
public extension Array where Element == any ConstraintType {
    
    subscript<ID>(_ elementId: ID) -> NSLayoutConstraint? where ID: Hashable, Element.Body: Identifiable {
        self.first { type in
            if let identified = (type as? (any Identifiable))?.id as? ID {
                return identified == elementId
            } else {
                return false
            }
        }?.constraint
    }
    
    var allLayoutConstraints: [NSLayoutConstraint] {
        self.map({$0.constraint})
    }
}
#endif
