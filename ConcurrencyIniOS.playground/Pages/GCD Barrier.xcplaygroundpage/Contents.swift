//: [⬅ GCD Groups](@previous)

import Foundation
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

//: ## GCD Barriers
//: When you're using asynchronous calls you need to conside thread safety.
//: Consider the following object:

let nameChangingPerson = Person(firstName: "Alison", lastName: "Anderson")

//: The `Person` class includes a method to change names:

nameChangingPerson.changeName(firstName: "Brian", lastName: "Biggles")
nameChangingPerson.name

//: What happens if you try and use the `changeName(firstName:lastName:)` simulataneously from a concurrent queue?

let workerQueue = dispatch_queue_create("com.raywenderlich.worker", DISPATCH_QUEUE_CONCURRENT)
let nameChangeGroup = dispatch_group_create()

let nameList = [("Charlie", "Cheesecake"), ("Delia", "Dingle"), ("Eva", "Evershed"), ("Freddie", "Frost"), ("Gina", "Gregory")]

for name in nameList {
  dispatch_group_async(nameChangeGroup, workerQueue) {
    nameChangingPerson.changeName(firstName: name.0, lastName: name.1)
    print("Current Name: \(nameChangingPerson.name)")
  }
}

dispatch_group_notify(nameChangeGroup, dispatch_get_main_queue()) {
  print("Final name: \(nameChangingPerson.name)")
  //XCPlaygroundPage.currentPage.finishExecution()
}

dispatch_group_wait(nameChangeGroup, DISPATCH_TIME_FOREVER)

//: __Result:__ `nameChangingPerson` has been left in an inconsistent state.


//: ### Dispatch Barrier
//: A barrier allows you add a task to a concurrent queue that will be run in a serial fashion. i.e. it will wait for the currently queued tasks to complete, and prevent any new ones starting.

class ThreadSafePerson: Person {
  
  let isolationQueue = dispatch_queue_create("com.raywenderlich.person.isolation", DISPATCH_QUEUE_CONCURRENT)
  
  override func changeName(firstName firstName: String, lastName: String) {
    dispatch_barrier_async(isolationQueue) {
      super.changeName(firstName: firstName, lastName: lastName)
    }
  }
  
  override var name: String {
    var result = ""
    dispatch_sync(isolationQueue) {
      result = super.name
    }
    return result
  }
}


print("\n=== Threadsafe ===")

let threadSafeNameGroup = dispatch_group_create()

let threadSafePerson = ThreadSafePerson(firstName: "Anna", lastName: "Adams")

for name in nameList {
  dispatch_group_async(threadSafeNameGroup, workerQueue) {
    threadSafePerson.changeName(firstName: name.0, lastName: name.1)
    print("Current threadsafe name: \(threadSafePerson.name)")
  }
}

dispatch_group_notify(threadSafeNameGroup, dispatch_get_main_queue()) {
  print("Final threadsafe name: \(threadSafePerson.name)")
  XCPlaygroundPage.currentPage.finishExecution()
}

/*:
 ---
 Hope you enjoyed this playground introduction to concurrency on iOS. Any questions please feel free to shout at me on twitter — I'm [@iwantmyrealname](https://twitter.com/iwantmyrealname).
 
 —sam
 
 
 ![Razeware](razeware_64.png)
 
 © Razeware LLC, 2016
 */
