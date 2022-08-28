# AutolayoutExtension

A light weight, clutter-free, declarative syntax to Autolayout. (⚠️ Requires Swift 5.7)

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
| :---- | :----------------- | :---------- |
| `.constraint(equalTo:)` | ``EqualTo`` | `NSLayoutAnchor<Axis>` |
| `.constraint(equalTo:constant)` | ``EqualToConstant`` | `NSLayoutDimension` |
| `.constraint(greaterThanOrEqualTo:)` | ``GreaterThanOrEqualTo`` | `NSLayoutAnchor<Axis>` |
| `.constraint(greaterThanOrEqualTo:constant)` | ``GreaterThanOrEqualToConstant`` | `NSLayoutDimension` | 
| `.constraint(lessThanOrEqualTo:)` | ``LessThanOrEqualTo`` |`NSLayoutAnchor<Axis>` |
| `.constraint(lessThanOrEqualTo:Constant)` | ``LessThanOrEqualToConstant`` | `NSLayoutDimension` |

## Modifiers
There 3 in-built constraint modifiers available. 

1. `.constant(_ constant: CGFloat)`
2. `.priority(_ priority : UILayoutPriority)`
3. `.id<ID: Hashable>(_ id: ID)`

## Example

```swift
import AutolayoutExtension
import UIKit

class AView: UIView {
    var condition: Bool = false {
        didSet {
            self.updateLayout()
        }
    }
    
    private var labelTopConstraint: NSLayoutConstraint?
    private var imageBottomConstraint: NSLayoutConstraint?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureSubviews()
    }
    
    private func configureSubviews() {
        self.addSubview(titleLabel)
        self.addSubview(imageView)
        
        let topAnchorID = UUID()
        let bottomAnchorID = UUID()
        
        let labelConstraints = self.constraint(titleLabel) {
            EqualTo(\.leadingAnchor)
            EqualTo(\.trailingAnchor)
            EqualTo(\.topAnchor)
                .constant(24)
                .id(topAnchorID)
            EqualToConstant(\.heightAnchor, constant: 32)
        }
        
        let imageConstraints = self.constraint(imageView) {
            EqualTo(\.centerXAnchor)
            GreaterThanOrEqualTo(\.leadingAnchor)
                .constant(12)
            EqualTo(\.topAnchor, with: titleLabel.bottomAnchor)
                .constant(12)
            EqualTo(\.bottomAnchor)
                .priority(.defaultHigh)
                .id(bottomAnchorID)
        }
        
        self.labelTopConstraint = labelConstraints[topAnchorID]
        self.imageBottomConstraint = imageConstraints[bottomAnchorID]
    }
    
    private func updateLayout() {
        self.labelTopConstraint?.constant = condition ? 24 : 32
        self.imageBottomConstraint?.constant = condition ? 24 : 0
        self.layoutIfNeeded()
    }
}
```
