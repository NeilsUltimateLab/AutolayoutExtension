# KeyPaths

Usage of KeyPath for limiting `UIView` properties to `NSLayoutAnchor` classes.

## Overview

As per the Apple Developer Documentation,

> A key path from a specific root type to a specific resulting value type.

A Type safe way to access the properties of a data type. All Data types have a supportive subscript accepting a generic KeyPath.

The Syntax of the KeyPath is like `KeyPath<Root, Value>`

```swift
let colorKeyPath = \UIView.backgroundColor
```

The type of `colorKeyPath` is `ReferenceWritableKeyPath<UIView, UIColor?>`

```swift
let view = UIView()
let color = view[keyPath: colorKeyPath]
```

This will emit the `UIColor?` type for `color` because the KeyPath route is from `UIView` to `UIColor?`. 

Similarly, `\UIView.widthAnchor` will result in `KeyPath<UIView, NSLayoutDimension>`. 

```swift
let view = UIView()
let widthAnchorKeyPath: KeyPath<UIView, NSLayoutDimension> = \UIView.widthAnchor
let widthAnchor: NSLayoutDimension = view[keyPath: widthAnchorKeyPath]
```

## Layout
 `UIView` properties for Autolayout. 

UIView has several computed properties of subclass of NSLayoutAnchor that are used to create autolayout relations. 

```swift
extension UIView {

    /* Constraint creation conveniences. See NSLayoutAnchor.h for details.
    */
    open var leadingAnchor: NSLayoutXAxisAnchor { get }
    open var trailingAnchor: NSLayoutXAxisAnchor { get }
    open var leftAnchor: NSLayoutXAxisAnchor { get }
    open var rightAnchor: NSLayoutXAxisAnchor { get }
    open var topAnchor: NSLayoutYAxisAnchor { get }
    open var bottomAnchor: NSLayoutYAxisAnchor { get }
    open var widthAnchor: NSLayoutDimension { get }
    open var heightAnchor: NSLayoutDimension { get }
    open var centerXAnchor: NSLayoutXAxisAnchor { get }
    open var centerYAnchor: NSLayoutYAxisAnchor { get }
    open var firstBaselineAnchor: NSLayoutYAxisAnchor { get }
    open var lastBaselineAnchor: NSLayoutYAxisAnchor { get }
}
```

Further visiting the types. we discover that NSLayoutAnchor is a special generic class.
```swift
@MainActor open class NSLayoutAnchor<AnchorType> : NSObject, NSCopying, NSCoding where AnchorType : AnyObject { ... }
```

So we can leverage this generic code as below.

```swift
public struct EqualTo<L, Axis>: ConstraintProvider where L: NSLayoutAnchor<Axis> { ... }
```

Here Generic `L` means any subclass of `NSLayoutAnchor<Axis>` where `Axis` is also a Generic type.

```swift
public struct EqualTo<L, Axis>: ConstraintProvider where L: NSLayoutAnchor<Axis> { 
    let from: KeyPath<UIView, L>
    let toKeyPath: KeyPath<UIView, L>

    public init(_ keyPath: KeyPath<UIView, L>) {
        from = keyPath
        toKeyPath = keyPath
    }

    public func constraint(_ parent: UIView, _ child: UIView) -> some ConstraintType {
        let constraint = child[keyPath: from].constraint(equalTo: parent[keyPath: toKeyPath])
        return AnyConstraint(constraint)
    }
}
```
