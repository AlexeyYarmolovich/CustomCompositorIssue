//
//  ViewController.swift
//  CustomCompositorPlayIssue
//
//  Created by Alexey Yarmolovich on 06/12/2023.
//

import UIKit
import AVFoundation

class PlayerLayerView: UIView {
  var player: AVPlayer? {
    get {
      return playerLayer.player
    }
    set {
      playerLayer.player = newValue
    }
  }

  var playerLayer: AVPlayerLayer {
    return layer as! AVPlayerLayer
  }

  override static var layerClass: AnyClass {
    return AVPlayerLayer.self
  }
}

class ViewController: UIViewController {
  let playerLayerView = PlayerLayerView()

  var currentStack: AVFoundationStack?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(playerLayerView)
    playerLayerView.frame = view.bounds.inset(by: .init(top: 200, left: 0, bottom: 0, right: 0))
    playerLayerView.backgroundColor = .gray

    let viewWidth = view.bounds.width
    let buttonSize = CGSize(width: viewWidth / 2, height: 200)
    let showRegularVideoButton = UIButton(type: .system)
    showRegularVideoButton.setTitle("Show regular video", for: .normal)
    showRegularVideoButton.addTarget(self, action: #selector(showRegularVideoTap), for: .touchUpInside)
    view.addSubview(showRegularVideoButton)
    showRegularVideoButton.frame = .init(origin: .zero, size: buttonSize)

    let showVideoWithIssueButton = UIButton(type: .system)
    showVideoWithIssueButton.setTitle("Show video with issue", for: .normal)
    showVideoWithIssueButton.addTarget(self, action: #selector(showVideoWithIssueTap), for: .touchUpInside)
    view.addSubview(showVideoWithIssueButton)
    showVideoWithIssueButton.frame = .init(origin: .init(x: viewWidth / 2, y: 0), size: buttonSize)
  }


  @objc func showRegularVideoTap() {
    let regularVideoUrl = Bundle.main.url(forResource: "regularVideo", withExtension: "MOV")!
    currentStack = .init(assetUrl: regularVideoUrl)
    playerLayerView.player = currentStack?.player
    playerLayerView.player?.play()
  }

  @objc func showVideoWithIssueTap() {
    let regularVideoUrl = Bundle.main.url(forResource: "videoWithIssue", withExtension: "MOV")!
    currentStack = .init(assetUrl: regularVideoUrl)
    playerLayerView.player = currentStack?.player
    playerLayerView.player?.play()
  }
}

