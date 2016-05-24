//: [Previous](@previous)

import UIKit

let imageNames = ["dark_road_small", "train_day", "train_dusk", "train_night"]
let images = imageNames.flatMap { UIImage(named: "\($0).jpg") }
images

class TiltShiftOperation: NSOperation {
  var inputImage: UIImage?
  var outputImage: UIImage?

  override func main() {
    outputImage = tiltShift(inputImage)
  }
}

let queue = NSOperationQueue()
queue.maxConcurrentOperationCount = 2

var operations = [TiltShiftOperation]()

duration {
  for image in images {
    let op = TiltShiftOperation()
    op.inputImage = image
    operations += [op]
    
    queue.addOperation(op)
  }
}

duration {
  queue.waitUntilAllOperationsAreFinished()
}
  
let output = operations.flatMap { $0.outputImage }
output



//: [Next](@next)
