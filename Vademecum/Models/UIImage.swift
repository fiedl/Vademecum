import UIKit

extension UIImage {

  // http://stackoverflow.com/a/8858464/2066546
  //
  func imageScaledToSize(size: CGSize) -> UIImage {
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    //draw
    self.drawInRect(CGRectMake(0.0, 0.0, size.width, size.height))
    //capture resultant image
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }

  func imageScaledToFitSize(size: CGSize) -> UIImage {
    //calculate rect
    let aspect: CGFloat = self.size.width / self.size.height
    if size.width / aspect <= size.height {
      return self.imageScaledToSize(CGSizeMake(size.width, size.width / aspect))
    }
    else {
      return self.imageScaledToSize(CGSizeMake(size.height * aspect, size.height))
    }
  }

  func imageScaled(factor: CGFloat) -> UIImage {
    return self.imageScaledToSize(CGSizeMake(size.width * factor, size.height * factor))
  }

}