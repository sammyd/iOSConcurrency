/*:
 # Concurrency in iOS
 ## iOSCon 2016
 ## Sam Davies · [@iwantmyrealname](https://twitter.com/iwantmyrealname)
 
 This playground forms the basis of a talk presented at [iOSCon 2016](https://skillsmatter.com/conferences/7598-ioscon-2016-the-conference-for-ios-and-swift-developers).
 
 The following represents the pages contained within this playground

 - [NSOperation](NSOperation)
 - [NSOperationQueue](NSOperationQueue)
 - [Wrapping Aysnc Functions in NSOperation](NSOperation%20Async)
 - [Inter-Operation Dependencies](NSOperation%20Dependencies)
 - [NSOperation in Practice](NSOperation%20in%20Practice)
 - [Grand Central Dispatch](Grand%20Central%20Dispatch)
 - [GCD Groups](GCD%20Groups)
 - [GCD Barrier](GCD%20Barrier)

---
 
 ## NSOperation
 
 `NSOperation` is a high-level abstraction that represents _"a unit of work"_. You can use this to wrap some sort of functionality, and then pass this off to be executed concurrently.
 */

import UIKit

//: `tiltShift()` is a function that applies a tilt-shift-like filter to a `UIImage`, and as such it's rather (artificially) slow.

let image = UIImage(named: "dark_road_small.jpg")
duration { 
  let result = tiltShift(image)
}

var outputImage: UIImage?

//: You can use the `NSBlockOperation` subclass of `NSOperation` to easily wrap some functionality.

//TODO: NSBlockOperation

//: You can then execute this operation with the `start()` method:
//TODO: start


outputImage


/*:
 Although `NSBlockOperation` has a very low bar for entry, it's not especially flexible. It's more usual to subclass `NSOperation` directly, and specialise it to particular functionality.
 
 When subclassing, create properties for input and output objects, and then override the `main()` method to perform the work.
 */
class TiltShiftOperation: NSOperation {
  //TODO: add properties and override main()
  
}

let mySecondOperation = TiltShiftOperation()
// TODO: set input image


/*:
 Once you've created an instance of the operation, and set the input value, you can go ahead and call `start()` to kick off the execution.
 
 - note:
 Calling `start()` might seem a little strange, but don't worry - you won't be doing it for long...
 
 */
mySecondOperation.start()

// TODO: view output image


//: [➡NSOperationQueue](NSOperationQueue)

