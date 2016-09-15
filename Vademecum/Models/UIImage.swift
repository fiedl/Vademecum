import UIKit

extension UIImage {

  // http://stackoverflow.com/a/8858464/2066546
  //
  func imageScaledToSize(_ size: CGSize) -> UIImage {
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    //draw
    self.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
    //capture resultant image
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }

  func imageScaledToFitSize(_ size: CGSize) -> UIImage {
    //calculate rect
    let aspect: CGFloat = self.size.width / self.size.height
    if size.width / aspect <= size.height {
      return self.imageScaledToSize(CGSize(width: size.width, height: size.width / aspect))
    }
    else {
      return self.imageScaledToSize(CGSize(width: size.height * aspect, height: size.height))
    }
  }

  func imageScaled(_ factor: CGFloat) -> UIImage {
    return self.imageScaledToSize(CGSize(width: size.width * factor, height: size.height * factor))
  }

}
