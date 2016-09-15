import UIKit

class EmptyViewController: UIViewController {
  var applicationController: ApplicationController?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = UIColor.white
    addWappenImage()
  }

  func addWappenImage() {
    let image = UIImage(named: "Wappen")
    let imageView = UIImageView(image: image!)

    imageView.sizeToFit()
    self.view.addSubview(imageView)

    imageView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addConstraints([
      NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 1),
      NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 1)
    ])
  }

}
