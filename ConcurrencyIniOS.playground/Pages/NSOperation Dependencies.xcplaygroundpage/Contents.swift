//: [Previous](@previous)
/*:
 ## Chaining NSOperations
 
 Standalone operations are useful, but the true power from `NSOperation` comes from when you chain them together, building up a complex workflow from small parts.
 
 In order to achieve this, you need to be able to pass the result of one operation to the next in the chain. This can be achieved using the `dependencies` property of `NSOperation`.
 
 In this demo, you have two operations - one the same filtering one you've been using, and the other one that simulates loading the source image over a network.
 
 - example:
 You can imagine that you might need to build up a chain that involves even more steps:
   - Retrieve source name from a data store
   - Download an image from a network
   - Decompress the image using a custom decompressor
   - Apply a filter to the image
   - Apply a second filter to the image
   - Display the image
 \
 Each of these tasks could be modelled as an `NSOperation`, and the dependencies architecture would ensure that each operation will only begin once the appropriate data has been produced from a previous operation.
 
 This approach allows you to break down complex tasks into smaller, reusable operations which compose together nicely. It can lead to cleaner code. However, be warned that as with any asynchronous code, debugging can become more challenging.
 
 - note:
 More than one operation can depend on another, so you can actually build a dependency graph - you're not limited to a simple chain. The great part of this is that you don't have to manage the scheduling of any of these - the operation queue handles it all for you.
 */
import UIKit

//: An operation that loads the file "over the network":
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

//: The same filtering operation you saw before. The `main()` method now attempts to find an input image in its dependencies if the `inputImage` property hasn't already been set.
class TiltShiftOperation: NSOperation {
  var inputImage: UIImage?
  var outputImage: UIImage?
  
  override func main() {
    if let dependencyImageProvider = dependencies
    .filter({ $0 is FilterDataProvider})
    .first as? FilterDataProvider
      where inputImage == .None {
      inputImage = dependencyImageProvider.outputImage
    }
    outputImage = tiltShift(inputImage)
  }
}


//: Rather than coding directly to concrete implementations, define a protocol that represents _"an object that can provide data to an image filter"_. This makes the code that searches dependencies far less brittle.
protocol FilterDataProvider {
  var outputImage: UIImage? { get }
}

extension ImageLoadOperation: FilterDataProvider {
  
}


/*:
 To add a dependency to an `NSOperation` object, use the `addDependency()` method.
 However, it's a rare case when a custom operator can make the code easier to read.
 - important:
 Heed all the usual warnings about custom operators. This is a situation where they can offer genuine clarity, but that isn't often the case.
 */
infix operator |> { associativity left precedence 150 }
func |>(lhs: NSOperation, rhs: NSOperation) -> NSOperation {
  rhs.addDependency(lhs)
  return rhs
}


//: Create the relevant operations
let imageLoad = ImageLoadOperation()
let filter = TiltShiftOperation()

//: Set the input parameter on the image loading operation:
imageLoad.inputName = "train_day.jpg"

//: And set the dependency chain
imageLoad |> filter

//: Add both operations to the operation queue
let queue = NSOperationQueue()
duration {
  queue.addOperations([imageLoad, filter], waitUntilFinished: true)
}


filter.outputImage


//: [➡ NSOperation in Practice](@next)
