//
//  SampleHandler.swift
//  ScreenRecordingExt
//
//  Created by Varun Bansal on 21/02/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import ReplayKit
import Photos


class SampleHandler: RPBroadcastSampleHandler {
  
    var assetWriter: AVAssetWriter!
    var videoInput:AVAssetWriterInput!
    var isWritingStarted:Bool = false
    var fileName:String?
    var gfileURL:URL?

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
      fileName = "test_file\(Int.random(in: 10 ..< 1000))"
      let fileURL = URL(fileURLWithPath: FileSystemUtil.filePath(fileName!))
      gfileURL = fileURL
      assetWriter = try! AVAssetWriter(outputURL: fileURL, fileType: AVFileType.mp4)
      let videoOutputSettings: Dictionary<String, Any> = [
           AVVideoCodecKey : AVVideoCodecType.h264,
           AVVideoWidthKey : UIScreen.main.bounds.size.width,
           AVVideoHeightKey : UIScreen.main.bounds.size.height
      ];
      videoInput  = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: videoOutputSettings)
      videoInput.expectsMediaDataInRealTime = true
      assetWriter.add(videoInput)
      assetWriter.startWriting()
    }
    
    override func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
    }
    
    override func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
    }
    
    override func broadcastFinished() {
      let dispatchGroup = DispatchGroup()
      dispatchGroup.enter()
      print("start the end")
      self.videoInput.markAsFinished()
      print("start the end 2")
      self.assetWriter.finishWriting {
        do {
//          PHPhotoLibrary.shared().performChanges({
//            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.gfileURL))
//          }) { (saved, error) in
//            if saved {
//              print("video saved")
//            } else {
//              print("\(error)")
//            }
//            dispatchGroup.leave()
//          }
          print("start the end 3")
          let sharedContainerURL :URL?  = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.org.reactjs.native.example.ScreenRecordingDemo")
          let sourceUrl = sharedContainerURL?.appendingPathComponent("\(self.fileName!).mp4")
          print("copying to \(sourceUrl)")
          try FileManager.default.copyItem(at: self.gfileURL!, to: sourceUrl!)
        } catch (let error) {
          print("Cannot copy item : \(error)")
        }
        dispatchGroup.leave()
      }
      print("start the end 4")
      dispatchGroup.wait()
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with bufferType: RPSampleBufferType) {
      if CMSampleBufferDataIsReady(sampleBuffer)
      {
        // Before writing the first buffer we need to start a session
        if !isWritingStarted
        {
          self.assetWriter.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
          isWritingStarted = true
        }
        
        if self.assetWriter.status == AVAssetWriter.Status.failed {
          print("Error occured, status =  (self.assetWriter.status.rawValue), \(self.assetWriter.error!.localizedDescription) \(String(describing: self.assetWriter.error))")
          return
        }
        if (bufferType == .video)
        {
          if self.videoInput.isReadyForMoreMediaData
          {
            self.videoInput.append(sampleBuffer)
          }
        }
      }
    }
}
