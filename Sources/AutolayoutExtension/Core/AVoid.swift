//
//  AVoid.swift
//  
//
//  Created by Neil Jain on 6/25/22.
//

#if os(iOS)
import UIKit

/// An Internal structure to mimic the `Swift.Void` extension to ``ConstraintType`` conformance.
struct AVoid {}

/// Extending ``AVoid`` to ``ConstraintType`` protocol.
extension AVoid: ConstraintType {
    var body: AVoid { AVoid() }
    var constraint: NSLayoutConstraint { fatalError() }
}

/// Exending ``ConstraintType`` to have body type ``AVoid`` by default.
extension ConstraintType where Body == AVoid {
    var body: AVoid { AVoid() }
}
#endif
