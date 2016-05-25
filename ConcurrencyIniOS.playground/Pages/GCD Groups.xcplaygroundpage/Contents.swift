//: [⬅ Grand Central Dispatch](@previous)
/*:
 ## Dispatch Groups
 
 Dispatch groups are a feature of GCD that allow you to perform an action when a group of GCD operations has completed. This offers a really simple way to keep track of the progress of a set of operations, rather than having to implement something to keep track yourself.
 
 When you're responsible for dispatching blocks yourself, it's really easy to disptach a block into a particular dispatch group, using the `dispatch_group_*()` family of functions, but the real power comes from being able to wrap existing async functions in dispatch groups.
 
 In this demo you'll see how you can use dispatch groups to run an action when a set of disparate animations has completed.
 */
import UIKit
import XCPlayground

//: Create a new animation function on `UIView` that wraps an existing animation function, but now takes a dispatch group as well.
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

//: Create a disptach group with `dispatch_group_create()`:
let animationGroup = dispatch_group_create()

//: The animation uses the following views
let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
view.backgroundColor = UIColor.redColor()
let box = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
box.backgroundColor = UIColor.yellowColor()
view.addSubview(box)

XCPlaygroundPage.currentPage.liveView = view

//: The following completely independent animations now use the dispatch group so that you can determine when all of the animations have completed:
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


//: `dispatch_group_notify()` allows you to specify a block that will be executed only when all the blocks in that dispatch group have completed:
dispatch_group_notify(animationGroup, dispatch_get_main_queue()) {
  print("Animations completed!")
  XCPlaygroundPage.currentPage.finishExecution()
}

//: [➡ Thread safety with GCD Barriers](@next)
