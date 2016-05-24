import Foundation

public class AsyncOperation: NSOperation {
  public enum State: String {
    case Ready, Executing, Finished
    
    private var keyPath: String {
      return "is" + rawValue
    }
  }
  
  public var state = State.Ready {
    willSet {
      willChangeValueForKey(newValue.keyPath)
      willChangeValueForKey(state.keyPath)
    }
    didSet {
      didChangeValueForKey(oldValue.keyPath)
      didChangeValueForKey(state.keyPath)
    }
  }
}


extension AsyncOperation {
  // NSOperation Overrides
  override public var ready: Bool {
    return super.ready && state == .Ready
  }
  
  override public var executing: Bool {
    return state == .Executing
  }
  
  override public var finished: Bool {
    return state == .Finished
  }
  
  override public var asynchronous: Bool {
    return true
  }
  
  override public func start() {
    if cancelled {
      state = .Finished
      return
    }
    
    main()
    state = .Executing
  }
  
  public override func cancel() {
    state = .Finished
  }
}


infix operator |> { associativity left precedence 150 }
public func |>(lhs: NSOperation, rhs: NSOperation) -> NSOperation {
  rhs.addDependency(lhs)
  return rhs
}

