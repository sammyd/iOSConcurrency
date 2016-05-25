//: [⬅ NSOperation in Practice](@previous)
/*:
 ## GCD Queues
 NSOperation queues are built on top of a technology called `libdispatch`, or *Grand Central Dispatch*. This is an advanced open-source technology that underpins concurrent programming on Apple technologies. It uses the now-familiar queuing model to greatly simplify concurrent programming, but is a C-level interface. This can make it slightly more challenging to work with.
 */
import UIKit
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
/*:
 ### Using a Global Queue
 iOS has some global queues, where every task eventually ends up being executed. You can use these directly. You need to use the main queue for UI updates.
 */
//TODO: Create a couple of queues

//: ### Creating your own Queue
//: Creating your own queues allow you to specify a label, which is super-useful for debugging.
//: You can specify whether the queue is serieal (default) or concurrent (see later).
//: You can also specify the QOS or priority (here be dragons)
let attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0)
let workerQueue = dispatch_queue_create("com.raywenderlich.worker", attr)


//: ### Getting the queue name
//: You can't get hold of the "current queue", but you can obtain its name - useful for debugging
func currentQueueName() -> String? {
  let label = dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL)
  return String(CString: label, encoding: NSUTF8StringEncoding)
}

//TODO: use the currentQueueName() function


//: ### Dispatching work asynchronously
//: Send some work off to be done, and then continue on—don't await a result
print("=== Sending asynchronously to Worker Queue ===")
//TODO: Async dispatch the next line
print("=== ASYNC:: Executing on \(currentQueueName()) ===")

print("=== Completed sending asynchronously to worker queue ===\n")



//: ### Dispatching work synchronously
//: Send some work off and wait for it to complete before continuing (here be more dragons)
print("=== Sending SYNChronously to Worker Queue ===")
//TODO: sync dispatch the following line:
print("=== SYNC:: Executing on \(currentQueueName()) ===")

print("=== Completed sending synchronously to worker queue ===\n")



//: ### Concurrent and serial queues
//: Serial allows one job to be worked on at a time, concurrent multitple
func doComplexWork() {
  sleep(1)
  print("\(currentQueueName()) :: Done!")
}

print("=== Starting Serial ===")
//TODO: Dispatch to a serial queue

sleep(5)

//TODO: Create a concurrent queue

print("\n=== Starting concurrent ===")
// TODO: dispatch to concurrent

sleep(5)

XCPlaygroundPage.currentPage.finishExecution()


//: [➡ GCD Groups](@next)
