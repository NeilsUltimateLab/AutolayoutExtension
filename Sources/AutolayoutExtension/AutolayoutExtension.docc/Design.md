# Design

The Design of the AutolayoutExtension.

## Overview

This started with some inspiration from **SwiftUI** and **Objc.io**'s exploration [Auto Layout with Key Paths](https://www.objc.io/blog/2018/10/30/auto-layout-with-key-paths/).

One can think of this as a natural extension to above blog post as declarative semantics allows many modification points as modifiers to constraints, like adding `.constants` only when required, a custom identifier `.id` to a perticular relationship to indentify and change the relation later and more similar to `SwiftUI`'s `viewModifier`s.

### The Protocol

```swift
public protocol ConstraintProvider {
    associatedtype Constraint: ConstraintType

    func constraint(_ parent: UIView, _ child: UIView) -> Constraint
}
```
This is a basic building block allows to create some relation between the two views. Here instead of directly using relation in form of `NSLayoutConstraint`, a generic ``ConstraintType`` is choosen to allow any relation related to `NSLayoutConstraint`. (See ``Identified`` for usage details)

- Example: An Equal relation

```swift
public struct EqualTo<L, Axis>: ConstraintProvider where L: NSLayoutAnchor<Axis> {
    ...
    public init(_ from: KeyPath<UIView, L>, _ toKeyPath: KeyPath<UIView, L>) {
        self.from = from
        self.toKeyPath = toKeyPath
    }

    public func constraint(_ parent: UIView, _ child: UIView) -> some ConstraintType {
        let constraint = child[keyPath: from].constraint(equalTo: parent[keyPath: toKeyPath])
        return AnyConstraint(constraint)
    }
}
```
This ``EqualTo`` type represents
```swift
childView.leadingAnchor.constraint(equalTo: parent.leadingAnchor)
```

Now that we have seen that how the basic protocol is used to declare the layout relation. Lets see how we can modify these relation ships.

### The Modifier

```swift
public protocol ConstraintModifier: ConstraintProvider {
    associatedtype Provider = ConstraintProvider
    var provider: Self.Provider { get set }
}
```

- Example 1: Modifying properties of `NSLayoutConstraint`. 

```swift
public struct Modified<Provider>: ConstraintModifier where Provider: ConstraintProvider {
    var modifying: (NSLayoutConstraint)->Void
    public var provider: Provider
    ...
}
```

This uses a `modifying` closure to change `NSLayoutConstraint` properties like `constant`, `priority` etc.

- Example 2: Constraint with ID

```swift
struct Identified<Provider, ID: Hashable>: ConstraintModifier where Provider: ConstraintProvider {
    var id: ID
    var provider: Provider
    ...
}
```
This `Identified` constraint modifier holds a generic `Hashable` id with constraint relations to identify specific constraint at future point. 

```swift
let centerYAnchorId = UUID()

self.constraints = self.view.anchor(anotherView) {
    EqualTo(\.centerXAnchor)
    EqualTo(\.centerYAnchor).id(centerYAnchorId)
}

func layoutSubviews() {
    ...
    self.constraints[centerYAnchorId].constant = 16
}
```
