//
//  CustomCompositor.swift
//  CustomCompositorPlayIssue
//
//  Created by Alexey Yarmolovich on 06/12/2023.
//

import Foundation
import AVFoundation
import CoreImage

class CustomCompositor: NSObject, AVVideoCompositing {
  private let renderingQueue = DispatchQueue(label: "com.example.fullcompositing.render")
  private lazy var context = CIContext()

  var sourcePixelBufferAttributes: [String: Any]? {
    [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]
  }

  var requiredPixelBufferAttributesForRenderContext: [String: Any] {
    [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]
  }

  func startRequest(_ request: AVAsynchronousVideoCompositionRequest) {
    print("startRequest")
    renderingQueue.async { [weak self] in
      guard let self else { return }
      autoreleasepool {
        let sourcePixelBuffer = request.sourceFrame(byTrackID: request.sourceTrackIDs[0].int32Value)!
        if let instruction = request.videoCompositionInstruction as? CustomInstruction {
          let compositingTime = request.compositionTime
          var inputImage = CIImage(cvPixelBuffer: sourcePixelBuffer)
            .transformed(by: instruction.orientationTransform)
          inputImage = inputImage
            .transformed(by: .init(translationX: -inputImage.extent.minX, y: -inputImage.extent.minY))

          let transformedImage = instruction.transform(inputImage, compositingTime)

          let newPixelBuffer = request.renderContext.newPixelBuffer()!
          self.context.render(transformedImage, to: newPixelBuffer)
          request.finish(withComposedVideoFrame: newPixelBuffer)
        } else {
          assertionFailure()
          request.finish(withComposedVideoFrame: sourcePixelBuffer)
        }
      }
    }
  }

  func renderContextChanged(_ newRenderContext: AVVideoCompositionRenderContext) {
  }
}
