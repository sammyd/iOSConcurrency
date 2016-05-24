import UIKit

public class ImageCell: UITableViewCell {
  public var fullImage: UIImage? {
    didSet {
      fullImageView?.image = fullImage
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
    
    NSLayoutConstraint.activateConstraints([
      fullImageView.bottomAnchor.constraintEqualToAnchor(bottomAnchor),
      fullImageView.topAnchor.constraintEqualToAnchor(topAnchor),
      fullImageView.leadingAnchor.constraintEqualToAnchor(leadingAnchor),
      fullImageView.trailingAnchor.constraintEqualToAnchor(trailingAnchor)
    ])
    
  }
  
}

