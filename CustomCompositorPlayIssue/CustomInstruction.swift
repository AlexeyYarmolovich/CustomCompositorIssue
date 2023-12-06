//
//  CustomInstruction.swift
//  CustomCompositorPlayIssue
//
//  Created by Alexey Yarmolovich on 06/12/2023.
//

import Foundation
import AVFoundation
import CoreImage

class CustomInstruction: NSObject, AVVideoCompositionInstructionProtocol {
  let passthroughTrackID: CMPersistentTrackID = kCMPersistentTrackID_Invalid
  let enablePostProcessing = true
  let containsTweening = true
  let requiredSourceTrackIDs: [NSValue]? = nil

  let timeRange: CMTimeRange
  let orientationTransform: CGAffineTransform
  let transform: (CIImage, CMTime) -> CIImage

  init(
    timeRange: CMTimeRange,
    orientationTransform: CGAffineTransform,
    transform: @escaping (CIImage, CMTime) -> CIImage
  ) {
    self.timeRange = timeRange
    self.orientationTransform = orientationTransform
    self.transform = transform
    super.init()
  }
}
