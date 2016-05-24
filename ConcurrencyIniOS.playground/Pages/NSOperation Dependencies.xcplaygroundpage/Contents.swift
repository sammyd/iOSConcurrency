//: [Previous](@previous)

import UIKit


class ImageLoadOperation: AsyncOperation {
  var inputName: String?
  var outputImage: UIImage?
  
  override func main() {
    simulateNetworkImageLoadAsync(self.inputName, callback: { (image) in
      self.outputImage = image
      self.state = .Finished
    })
  }
}


class TiltShiftOperation: NSOperation {
  var inputImage: UIImage?
  var outputImage: UIImage?
  
  override func main() {
    if let dependencyImageProvider = dependencies
      .filter({ $0 is FilterDataProvider })
      .first as? FilterDataProvider
      where inputImage == .None {
      inputImage = dependencyImageProvider.outputImage
    }
    
    outputImage = tiltShift(inputImage)
  }
}



protocol FilterDataProvider {
  var outputImage: UIImage? { get }
}

extension ImageLoadOperation: FilterDataProvider {
  
}


infix operator |> { associativity left precedence 150 }
func |>(lhs: NSOperation, rhs: NSOperation) -> NSOperation {
  rhs.addDependency(lhs)
  return rhs
}


let imageLoad = ImageLoadOperation()
imageLoad.inputName = "train_day.jpg"

let filter = TiltShiftOperation()


imageLoad |> filter



let queue = NSOperationQueue()
duration {
  queue.addOperations([imageLoad, filter], waitUntilFinished: true)
}


filter.outputImage


//: [Next](@next)
