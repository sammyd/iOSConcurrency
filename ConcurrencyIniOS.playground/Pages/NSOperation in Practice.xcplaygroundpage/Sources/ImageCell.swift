import UIKit

public class ImageCell: UITableViewCell {
  public var fullImage: UIImage? {
    didSet {
      fullImageView?.image = fullImage
    }
  }
  
  public func transitionToImage(image: UIImage?) {
    NSOperationQueue.mainQueue().addOperationWithBlock {
      if image == nil {
        self.fullImageView?.alpha = 0
      } else {
        self.fullImageView?.image = image
        UIView.animateWithDuration(0.4, animations: {
          self.fullImageView?.alpha = 1
        })
      }
    }
  }
  
  var fullImageView: UIImageView?
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    sharedInit()
  }
  
  override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    sharedInit()
  }
  
  
  func sharedInit() {
    fullImageView = UIImageView(image: fullImage)
    
    guard let fullImageView = fullImageView else { return }
    addSubview(fullImageView)
    
    fullImageView.contentMode = .ScaleAspectFill
    fullImageView.translatesAutoresizingMaskIntoConstraints = false
    fullImageView.clipsToBounds = true
    
    NSLayoutConstraint.activateConstraints([
      fullImageView.bottomAnchor.constraintEqualToAnchor(bottomAnchor),
      fullImageView.topAnchor.constraintEqualToAnchor(topAnchor),
      fullImageView.leadingAnchor.constraintEqualToAnchor(leadingAnchor),
      fullImageView.trailingAnchor.constraintEqualToAnchor(trailingAnchor)
    ])
    
  }
  
}

