//: # Concurrency in iOS
//: ## iOSCon 2016

import UIKit

let image = UIImage(named: "dark_road_small.jpg")
duration { 
  let result = tiltShift(image)
}

var outputImage: UIImage?

let myFirstOperation = NSBlockOperation { 
  outputImage = tiltShift(image)
}

myFirstOperation.start()

outputImage


class TiltShiftOperation: NSOperation {
  var inputImage: UIImage?
  var outputImage: UIImage?
  
  override func main() {
    outputImage = tiltShift(inputImage)
  }
}

let mySecondOperation = TiltShiftOperation()
mySecondOperation.inputImage = image

mySecondOperation.start()

mySecondOperation.outputImage




