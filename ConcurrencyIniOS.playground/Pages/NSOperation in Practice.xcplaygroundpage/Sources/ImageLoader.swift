import UIKit

public class ImageLoadOperation: AsyncOperation {
  public var inputName: String?
  public var outputImage: UIImage?
  
  public override func main() {
    simulateNetworkImageLoadAsync(self.inputName, callback: { (image) in
      self.outputImage = image
      self.state = .Finished
    })
  }
}


