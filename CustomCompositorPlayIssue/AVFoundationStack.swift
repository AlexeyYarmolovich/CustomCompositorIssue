//
//  AVFoundationStack.swift
//  CustomCompositorPlayIssue
//
//  Created by Alexey Yarmolovich on 06/12/2023.
//

import Foundation
import AVFoundation
import CoreImage

class AVFoundationStack: NSObject {
  let player: AVPlayer

  private let asset: AVURLAsset
  private let composition: AVMutableVideoComposition

  init(assetUrl: URL) {
    asset = AVURLAsset(url: assetUrl, options: [AVURLAssetPreferPreciseDurationAndTimingKey: true])
    composition = AVMutableVideoComposition(propertiesOf: asset)
    composition.customVideoCompositorClass = CustomCompositor.self
    let videoTrack = asset.tracks(withMediaType: .video)[0]
    let instruction = CustomInstruction(
      timeRange: videoTrack.timeRange,
      orientationTransform: videoTrack.preferredTransform.inverted(),
      transform: { input, _ in input }
    )

    composition.instructions = [instruction]

    let playerItem = AVPlayerItem(asset: asset)
    playerItem.videoComposition = composition
    player = .init(playerItem: playerItem)

    super.init()

    let isValid = composition.isValid(for: asset, timeRange: videoTrack.timeRange, validationDelegate: self)
    print("isValid: \(isValid)")
  }
}

extension AVFoundationStack: AVVideoCompositionValidationHandling {
  func videoComposition(_ videoComposition: AVVideoComposition, shouldContinueValidatingAfterFindingInvalidValueForKey key: String) -> Bool {
    print("shouldContinueValidatingAfterFindingInvalidValueForKey")
    return true
  }

  func videoComposition(_ videoComposition: AVVideoComposition, shouldContinueValidatingAfterFindingEmptyTimeRange timeRange: CMTimeRange) -> Bool {
    print("shouldContinueValidatingAfterFindingEmptyTimeRange")
    return true
  }

  func videoComposition(_ videoComposition: AVVideoComposition, shouldContinueValidatingAfterFindingInvalidTimeRangeIn videoCompositionInstruction: AVVideoCompositionInstructionProtocol) -> Bool {
    print("shouldContinueValidatingAfterFindingInvalidTimeRangeIn")
    return true
  }

  func videoComposition(_ videoComposition: AVVideoComposition, shouldContinueValidatingAfterFindingInvalidTrackIDIn videoCompositionInstruction: AVVideoCompositionInstructionProtocol, layerInstruction: AVVideoCompositionLayerInstruction, asset: AVAsset) -> Bool {
    print("shouldContinueValidatingAfterFindingInvalidTrackIDIn")
    return true
  }
}
