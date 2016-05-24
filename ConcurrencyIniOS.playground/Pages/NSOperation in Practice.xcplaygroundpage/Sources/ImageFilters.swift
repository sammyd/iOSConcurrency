import UIKit

public class TiltShiftOperation: NSOperation {
  public var inputImage: UIImage?
  public var outputImage: UIImage?
  
  public override func main() {
    if let dependencyImageProvider = dependencies
      .filter({ $0 is FilterDataProvider })
      .first as? FilterDataProvider
      where inputImage == .None {
      inputImage = dependencyImageProvider.outputImage
    }
    
    outputImage = tiltShift(inputImage)
  }
}



public protocol FilterDataProvider {
  var outputImage: UIImage? { get }
}

extension ImageLoadOperation: FilterDataProvider {
  
}

