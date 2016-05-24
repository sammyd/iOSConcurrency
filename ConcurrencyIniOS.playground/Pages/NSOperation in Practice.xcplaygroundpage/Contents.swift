//: [Previous](@previous)

import UIKit
import XCPlayground


let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 720))
tableView.registerClass(ImageCell.self, forCellReuseIdentifier: "ImageCell")
XCPlaygroundPage.currentPage.liveView = tableView
tableView.rowHeight = 400


class DataSource: NSObject {
  var imageNames: [String] = []
}


extension DataSource: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return imageNames.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath)
    
    if let cell = cell as? ImageCell {
      // Load and filter appropriate image
      let rawImage = simulateNetworkImageLoad(imageNames[indexPath.row])
      let filteredImage = tiltShift(rawImage)
      
      cell.fullImage = filteredImage
    }
    return cell
  }
}



let ds = DataSource()
ds.imageNames = ["dark_road_small.jpg", "train_day.jpg", "train_dusk.jpg", "train_night.jpg"]

tableView.dataSource = ds





//: [Next](@next)
