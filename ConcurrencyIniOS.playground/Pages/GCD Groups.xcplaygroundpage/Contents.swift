//: [Previous](@previous)

import UIKit
import XCPlayground

extension UIView {
  static func animateWithDuration(duration: NSTimeInterval, animations: () -> Void, group: dispatch_group_t, completion: ((Bool) -> Void)?) {
    dispatch_group_enter(group)
    animateWithDuration(duration, animations: animations, completion: {
      success in
      completion?(success)
      dispatch_group_leave(group)
    })
  }
}

//: Use the following dispatch group:
let animationGroup = dispatch_group_create()

//: The animation uses the following views
let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
view.backgroundColor = UIColor.redColor()
let box = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
box.backgroundColor = UIColor.yellowColor()
view.addSubview(box)

XCPlaygroundPage.currentPage.liveView = view

//: And then rewrite the following animation to be notified when all animations complete:
UIView.animateWithDuration(1, animations: {
  box.center = CGPoint(x: 150, y: 150)
  }, group: animationGroup, completion: {
    _ in
    UIView.animateWithDuration(2, animations: {
      box.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
      }, group: animationGroup, completion: nil)
})

UIView.animateWithDuration(4, animations: { () -> Void in
  view.backgroundColor = UIColor.blueColor()
  }, group: animationGroup, completion: nil)


//: Should only print once all the animations are complete
dispatch_group_notify(animationGroup, dispatch_get_main_queue()) {
  print("Animations completed!")
  //TODO: Uncomment the following line once you've completed implemention
  XCPlaygroundPage.currentPage.finishExecution()
}


//: [Next](@next)
