import Foundation

public class Person {
  private var firstName: String
  private var lastName: String
  
  public init(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
  }
  
  public func changeName(firstName firstName: String, lastName: String) {
    randomDelay(0.1)
    self.firstName = firstName
    randomDelay(1)
    self.lastName = lastName
  }
  
  public var name: String {
    return "\(firstName) \(lastName)"
  }
}
