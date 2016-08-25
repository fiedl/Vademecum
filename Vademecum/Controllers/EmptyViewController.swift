import UIKit

class EmptyViewController: UIViewController {
  var applicationController: ApplicationController?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = UIColor.whiteColor()
    addWappenImage()
  }

  func addWappenImage() {
    let image = UIImage(named: "Wappen")
    let imageView = UIImageView(image: image!)

    imageView.sizeToFit()
    self.view.addSubview(imageView)

    imageView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addConstraints([
      NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 1),
      NSLayoutConstraint(item: imageView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 1)
    ])
  }

}