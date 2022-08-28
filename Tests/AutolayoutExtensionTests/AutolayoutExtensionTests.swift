import XCTest
@testable import AutolayoutExtension

final class AutolayoutExtensionTests: XCTestCase {
    func testAutolayoutExtension() throws {
        let view = UIView()
        let otherView = UIView()
        
        let leadingID = UUID()
        let trailingID = UUID()
        let topID = UUID()
        let bottomID = UUID()
        
        let constraints = view.anchor(otherView) {
            EqualTo(\.leadingAnchor)
                .id(leadingID)
            EqualTo(\.trailingAnchor)
                .id(trailingID)
            EqualTo(\.topAnchor)
                .id(topID)
                .constant(12)
            EqualTo(\.bottomAnchor)
                .constant(-12)
                .id(bottomID)
            EqualToConstant(\.heightAnchor, constant: 200)
        }
        
        print(view.constraints)
        XCTAssertEqual(otherView.translatesAutoresizingMaskIntoConstraints, false)
        XCTAssertEqual(view.constraints.count, 4)
        XCTAssertEqual(constraints.count, 5)
        
        verifyActiveConstraints(for: constraints)
        
        let leadingConstraint = constraints[leadingID]
        let trailingConstraint = constraints[trailingID]
        let topConstraint = constraints[topID]
        let bottomConstraint = constraints[bottomID]
        
        XCTAssertNotNil(leadingConstraint)
        XCTAssertNotNil(trailingConstraint)
        XCTAssertNotNil(topConstraint)
        XCTAssertNotNil(bottomConstraint)
        
        XCTAssertEqual(topConstraint!.constant, 12)
        XCTAssertEqual(bottomConstraint!.constant, -12)
    }
    
    func testSiblingsViewConstraints() throws {
        let parent = UIView()
        let labelView = UILabel()
        let imageView = UIImageView()
        
        parent.addSubview(labelView)
        parent.addSubview(imageView)
        
        let firstChildConstraints = parent.constraint(labelView) {
            EqualTo(\.leadingAnchor)
            EqualTo(\.trailingAnchor)
            EqualTo(\.topAnchor)
            EqualToConstant(\.heightAnchor, constant: 50)
        }
        
        let secondChildConstraints = parent.constraint(imageView) {
            EqualTo(\.leadingAnchor)
            EqualTo(\.trailingAnchor)
            EqualTo(\.bottomAnchor)
            EqualTo(\.topAnchor, with: labelView.bottomAnchor)
            EqualToConstant(\.heightAnchor, constant: 50)
        }
        
        verifyActiveConstraints(for: firstChildConstraints)
        verifyActiveConstraints(for: secondChildConstraints)
        
        XCTAssertEqual(firstChildConstraints.count, 4)
        XCTAssertEqual(secondChildConstraints.count, 5)
        
        XCTAssertEqual(parent.constraints.count, 7)
        XCTAssertEqual(labelView.constraints.count, 1)
        XCTAssertEqual(imageView.constraints.count, 1)
    }
    
    func testRawSiblingConstraints() throws {
        let parent = UIView()
        let labelView = UILabel()
        let imageView = UIImageView()
        
        parent.addSubview(labelView)
        parent.addSubview(imageView)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        labelView.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        labelView.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        labelView.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
        labelView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        imageView.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        imageView.topAnchor.constraint(equalTo: labelView.bottomAnchor).isActive = true
        
        XCTAssertEqual(parent.constraints.count, 7)
        XCTAssertEqual(labelView.constraints.count, 1)
        XCTAssertEqual(imageView.constraints.count, 1)
    }
    
    func testConstraintPriority() {
        let parent = UIView()
        let labelView = UILabel()
        let topID = "topID"
        let bottomID = "BottomID"
        
        let constraints = parent.anchor(labelView) {
            EqualTo(\.leadingAnchor)
            EqualTo(\.trailingAnchor)
            EqualTo(\.topAnchor)
                .priority(.defaultHigh)
                .id(topID)
            EqualTo(\.bottomAnchor)
                .priority(.defaultLow)
                .id(bottomID)
        }
        
        let topConstraint = constraints[topID]
        let bottomConstraint = constraints[bottomID]
        XCTAssertNotNil(topConstraint)
        XCTAssertNotNil(bottomConstraint)
        
        XCTAssertEqual(bottomConstraint!.priority, .defaultLow)
        XCTAssertEqual(topConstraint!.priority, .defaultHigh)
        verifyActiveConstraints(for: constraints)
    }
    
    func verifyActiveConstraints(for constraints: [any ConstraintType]) {
        XCTAssertTrue(constraints.allLayoutConstraints.allSatisfy{$0.isActive == true})
    }
}
