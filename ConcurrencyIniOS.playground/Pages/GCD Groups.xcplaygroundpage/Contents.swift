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
    //TODO: provide implementation
  }
}

//: Create a disptach group with `dispatch_group_create()`:
//TODO: create a dispatch group

//: The animation uses the following views
let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
view.backgroundColor = UIColor.redColor()
let box = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
box.backgroundColor = UIColor.yellowColor()
view.addSubview(box)

XCPlaygroundPage.currentPage.liveView = view

//: The following completely independent animations now use the dispatch group so that you can determine when all of the animations have completed:
//TODO: update the following to use the new method with dispatch group
UIView.animateWithDuration(1, animations: {
  box.center = CGPoint(x: 150, y: 150)
  }, completion: {
    _ in
    UIView.animateWithDuration(2, animations: {
      box.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
      }, completion: nil)
})

UIView.animateWithDuration(4, animations: { () -> Void in
  view.backgroundColor = UIColor.blueColor()
  }, completion: nil)


//: `dispatch_group_notify()` allows you to specify a block that will be executed only when all the blocks in that dispatch group have completed:
//TODO: use dispatch_group_notify() to find when all animations are complete

//: [➡ Thread safety with GCD Barriers](@next)
