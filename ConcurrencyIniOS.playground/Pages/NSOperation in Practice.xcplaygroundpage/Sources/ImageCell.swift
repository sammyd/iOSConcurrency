/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

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

