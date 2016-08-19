import UIKit

extension UIView {

  /// Adds constraints to this `UIView` instances `superview` object to make sure this always has the same size as the superview.
  /// Please note that this has no effect if its `superview` is `nil` – add this `UIView` instance as a subview before calling this.
  func bindFrameToSuperviewBounds() {
    guard let superview = self.superview else {
      print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
      return
    }

    self.translatesAutoresizingMaskIntoConstraints = false
    superview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[subview]-0-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    superview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[subview]-0-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["subview": self]))
  }
  
}