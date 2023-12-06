# CustomCompositorIssue
This is a showcase of strange issue with AVFoundation with custom compositor and custom instruction
This is a test project with a quite strait forward setup in AVFoundationStack class:

1. I create AVAsset with video file captured on my iPhone 12 mini (4k 60fps, files are in the project) 
   
2. I create AVMutableVideoComposition for loaded asset, set custom Video Compositor, insert custom instruction CustomInstruction, create AVPlayerItem, insert composition to it and attempt to play the video.
     
4. Video Compositor do the following:
- a) takes frame and rotate it to match video track orientation
- b) apply arbitrary CIImage transform block that is passed inside CustomInstruction, in current example the transform block doesn’t apply any transformations and returns input image as is (in my production project there are various transformations but it’s not important for this issue)
5. CustomComposition is a container for the transformation block, orientation of the video track and other required field from AVVideoCompositionInstructionProtocol 5. This setup is wrapped in UI (ViewController.swift) where there are a player view and two buttons to setup stack and start playing a video, there are two videos in the project “regularVideo” is one of the many my testing videos that play correctly, second video is “videoWithIssue” it also my test video but it fail to play video (audio is still playing correctly) and there is no any error messages related to this.
  Both videos were captured on my iPhone 12 mini in same configuration (4k 60 fps) I don’t see any principal difference between them. If I comment code where I set my instruction video is playing correctly (except wrong orientation).

It also playing correctly if I use AVVideoComposition.init(asset:applyingCIFiltersWithHandler:) it serves same purpose as my setup but the reason why I decided to implement same behaviour is some bug inside this kind of composition, you confirmed it in previous TSI request (case number 5040055), so I decided to give a try to a custom implementation and faced another issue.
