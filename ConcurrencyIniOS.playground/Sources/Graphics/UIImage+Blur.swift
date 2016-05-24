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
import Accelerate

extension UIImage {
  public func applyBlurWithRadius(blurRadius: CGFloat, maskImage: UIImage? = nil) -> UIImage? {
    // Check pre-conditions.
    if (size.width < 1 || size.height < 1) {
      print("*** error: invalid size: \(size.width) x \(size.height). Both dimensions must be >= 1: \(self)")
      return nil
    }
    if self.CGImage == nil {
      print("*** error: image must be backed by a CGImage: \(self)")
      return nil
    }
    if maskImage != nil && maskImage!.CGImage == nil {
      print("*** error: maskImage must be backed by a CGImage: \(maskImage)")
      return nil
    }
    
    let __FLT_EPSILON__ = CGFloat(FLT_EPSILON)
    let screenScale = UIScreen.mainScreen().scale
    let imageRect = CGRect(origin: CGPointZero, size: size)
    var effectImage = self
    
    let hasBlur = blurRadius > __FLT_EPSILON__
    
    if hasBlur {
      func createEffectBuffer(context: CGContext) -> vImage_Buffer {
        let data = CGBitmapContextGetData(context)
        let width = vImagePixelCount(CGBitmapContextGetWidth(context))
        let height = vImagePixelCount(CGBitmapContextGetHeight(context))
        let rowBytes = CGBitmapContextGetBytesPerRow(context)
        
        return vImage_Buffer(data: data, height: height, width: width, rowBytes: rowBytes)
      }
      
      UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
      let effectInContext = UIGraphicsGetCurrentContext()!
      
      CGContextScaleCTM(effectInContext, 1.0, -1.0)
      CGContextTranslateCTM(effectInContext, 0, -size.height)
      CGContextDrawImage(effectInContext, imageRect, self.CGImage)
      
      var effectInBuffer = createEffectBuffer(effectInContext)
      
      
      UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
      let effectOutContext = UIGraphicsGetCurrentContext()!
      
      var effectOutBuffer = createEffectBuffer(effectOutContext)
      
      
      if hasBlur {
        // A description of how to compute the box kernel width from the Gaussian
        // radius (aka standard deviation) appears in the SVG spec:
        // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
        //
        // For larger values of 's' (s >= 2.0), an approximation can be used: Three
        // successive box-blurs build a piece-wise quadratic convolution kernel, which
        // approximates the Gaussian kernel to within roughly 3%.
        //
        // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
        //
        // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
        //
        
        let inputRadius = blurRadius * screenScale
        var radius = UInt32(floor(inputRadius * 3.0 * CGFloat(sqrt(2 * M_PI)) / 4 + 0.5))
        if radius % 2 != 1 {
          radius += 1 // force radius to be odd so that the three box-blur methodology works.
        }
        
        let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
        
        vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
        vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
        vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
      }
      
      effectImage = UIGraphicsGetImageFromCurrentImageContext()
      
      UIGraphicsEndImageContext()
      UIGraphicsEndImageContext()
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
    let outputContext = UIGraphicsGetCurrentContext()
    CGContextScaleCTM(outputContext, 1.0, -1.0)
    CGContextTranslateCTM(outputContext, 0, -size.height)
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage)
    
    // Draw effect image.
    if hasBlur {
      CGContextSaveGState(outputContext)
      if let image = maskImage {
        //CGContextClipToMask(outputContext, imageRect, image.CGImage);
        let effectCGImage = CGImageCreateWithMask(effectImage.CGImage, image.CGImage)
        if let effectCGImage = effectCGImage {
          effectImage = UIImage(CGImage: effectCGImage)
        }
      }
      CGContextDrawImage(outputContext, imageRect, effectImage.CGImage)
      CGContextRestoreGState(outputContext)
    }
    
    // Output image is ready.
    let outputImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return outputImage
  }
}
