# AutolayoutExtension

A light weight, clutter-free, declarative syntax to Autolayout.

## Overview

We all use Autolayout to arrange and position UI components in UIKit. And doing in code is quite an exercise to brain to imagine how this piece of code will take reflect on screen.

We need to think about buttons, labels, various controls, child views. All UI componenets and their relation in between, parent, child, siblings, safe area, layout guides, size classes 🤯.

Let's try to make this little simpler with some inspiration from **SwiftUI** and a lesser known friend Swift `KeyPaths`.

## The Point
We all have written code like this.

```swift
self.view.addSubview(otherView)
otherView.translatesAutoresizingMaskIntoConstraints = true

otherView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
otherView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
...
```

In above code, just to add the `leadingAnchor` to `otherView` with respect to `view` the whole line is very lengthy and wordy.

```swift
otherView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
```

What if we just write the same line using.
```swift
self.view.anchor(otherView) {
    EqualTo(\.leadingAnchor)
    EqualTo(\.trailingAnchor).constant(-16)
}
```
Much more clear, concise and readable at a glance.

## Map

| Native | AutolayoutExtension | Anchor Type | 
| :---- | :-----------------: | -----------: |
| `.constraint(equalTo:)` | ``EqualTo`` | `NSLayoutAnchor<Axis>` |
| `.constraint(equalTo:constant)` | ``EqualToConstant`` | `NSLayoutDimension` |
| `.constraint(greaterThanOrEqualTo:)` | ``GreaterThanOrEqualTo`` | `NSLayoutAnchor<Axis>` |
| `.constraint(greaterThanOrEqualTo:constant)` | ``GreaterThanOrEqualToConstant`` | `NSLayoutDimension` | 
| `.constraint(lessThanOrEqualTo:)` | ``LessThanOrEqualTo`` |`NSLayoutAnchor<Axis>` |
| `.constraint(lessThanOrEqualTo:Constant)` | ``LessThanOrEqualToConstant`` | `NSLayoutDimension` |
