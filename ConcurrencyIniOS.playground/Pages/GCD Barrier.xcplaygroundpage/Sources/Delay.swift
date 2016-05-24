import Foundation

func randomDelay(maxDuration: Double) {
  let randomWait = arc4random_uniform(UInt32(maxDuration * Double(USEC_PER_SEC)))
  usleep(randomWait)
}
