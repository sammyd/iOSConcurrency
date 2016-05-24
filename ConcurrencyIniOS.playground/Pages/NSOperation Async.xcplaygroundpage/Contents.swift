//: [Previous](@previous)

import UIKit

class AsyncOperation: NSOperation {
  enum State: String {
    case Ready, Executing, Finished
    
    private var keyPath: String {
      return "is" + rawValue
    }
  }
  
  var state = State.Ready {
    willSet {
      willChangeValueForKey(newValue.keyPath)
      willChangeValueForKey(state.keyPath)
    }
    didSet {
      didChangeValueForKey(oldValue.keyPath)
      didChangeValueForKey(state.keyPath)
    }
  }
}


extension AsyncOperation {
  // NSOperation Overrides
  override var ready: Bool {
    return super.ready && state == .Ready
  }
  
  override var executing: Bool {
    return state == .Executing
  }
  
  override var finished: Bool {
    return state == .Finished
  }
  
  override var asynchronous: Bool {
    return true
  }
  
  override func start() {
    if cancelled {
      state = .Finished
      return
    }
    
    main()
    state = .Executing
  }
  
  override func cancel() {
    state = .Finished
  }
}


class ImageLoadOperation: AsyncOperation {
  var inputName: String?
  var outputImage: UIImage?
  
  override func main() {
    duration {
      simulateNetworkImageLoadAsync(self.inputName, callback: { (image) in
        self.outputImage = image
        self.state = .Finished
      })
    }
  }
}

let queue = NSOperationQueue()


let imageLoad = ImageLoadOperation()
imageLoad.inputName = "train_dusk.jpg"

queue.addOperation(imageLoad)

duration {
  queue.waitUntilAllOperationsAreFinished()
}

imageLoad.outputImage

//: [Next](@next)
