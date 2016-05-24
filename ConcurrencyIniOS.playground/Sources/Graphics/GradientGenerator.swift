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

func topAndBottomGradient(size: CGSize, clearLocations: [CGFloat] = [0.35, 0.65], innerIntensity: CGFloat = 0.5) -> UIImage {
  
  let context = CGBitmapContextCreate(nil, Int(size.width), Int(size.height), 8, 0, CGColorSpaceCreateDeviceGray(), CGImageAlphaInfo.None.rawValue)
  
  let colors = [
    UIColor.whiteColor(),
    UIColor(white: innerIntensity, alpha: 1.0),
    UIColor.blackColor(),
    UIColor(white: innerIntensity, alpha: 1.0),
    UIColor.whiteColor()
    ].map { $0.CGColor }
  let colorLocations : [CGFloat] = [0, clearLocations[0], (clearLocations[0] + clearLocations[1]) / 2.0, clearLocations[1], 1]
  
  let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceGray(), colors, colorLocations)
  
  let startPoint = CGPoint(x: 0, y: 0)
  let endPoint = CGPoint(x: 0, y: size.height)
  CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions())
  
  let cgImage = CGBitmapContextCreateImage(context)
  
  return UIImage(CGImage: cgImage!)
}
