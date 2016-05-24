//: [Previous](@previous)

import UIKit
import XCPlayground


let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 720))
tableView.registerClass(ImageCell.self, forCellReuseIdentifier: "ImageCell")
XCPlaygroundPage.currentPage.liveView = tableView
tableView.rowHeight = 250



class ImageProvider {
  
  let queue = NSOperationQueue()
  
  init(imageName: String, completion: (UIImage?) -> ()) {
    let loadOp = ImageLoadOperation()
    let tiltShiftOp = TiltShiftOperation()
    let outputOp = ImageOutputOperation()
    
    loadOp.inputName = imageName
    outputOp.completion = completion
    
    loadOp |> tiltShiftOp |> outputOp
    
    queue.addOperations([loadOp, tiltShiftOp, outputOp], waitUntilFinished: false)
  }
  
  func cancel() {
    queue.cancelAllOperations()
  }
}

class DataSource: NSObject {
  var imageNames = [String]()
  var imageProviders = [NSIndexPath : ImageProvider]()
}

extension DataSource: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return imageNames.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath)
  }
}

extension DataSource: UITableViewDelegate {
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if let cell = cell as? ImageCell {
      let provider = ImageProvider(imageName: imageNames[indexPath.row], completion: { (image) in
          cell.transitionToImage(image)
      })
      imageProviders[indexPath] = provider
    }
  }
  
  func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if let cell = cell as? ImageCell {
      cell.transitionToImage(.None)
    }
    if let provider = imageProviders[indexPath] {
      provider.cancel()
      imageProviders.removeValueForKey(indexPath)
    }
  }
}


let ds = DataSource()
ds.imageNames = ["dark_road_small.jpg", "train_day.jpg", "train_dusk.jpg", "train_night.jpg", "dark_road_small.jpg", "train_day.jpg", "train_dusk.jpg", "train_night.jpg", "dark_road_small.jpg", "train_day.jpg", "train_dusk.jpg", "train_night.jpg", "dark_road_small.jpg", "train_day.jpg", "train_dusk.jpg", "train_night.jpg"]

tableView.dataSource = ds
tableView.delegate = ds




//: [Next](@next)
