//
//  RecordComponent.swift
//  ScreenRecordingDemo
//
//  Created by Varun Bansal on 21/02/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import ReplayKit
import Photos

@objc(RecordComponent)
class RecordComponent: RCTViewManager {
  
  override func view() -> UIView! {
    if #available(iOS 12.0, *) {
      let pickerView = RPSystemBroadcastPickerView(
        frame: CGRect(x: 0, y: 0, width: 50, height: 50))
      
      pickerView.translatesAutoresizingMaskIntoConstraints = false

      // Theme the picker view to match the white that we want.
      if let button = pickerView.subviews.first as? UIButton {
          button.imageView?.tintColor = UIColor.red
      }
      return pickerView
    } else {
      let label = UILabel()
      label.text = "Screen Recording Not Supported"
      return label
    }
  }
  
  @objc func showSaveView(_ node:NSNumber, fileName:String) {

    let sharedContainerURL :URL?  = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.org.reactjs.native.example.ScreenRecordingDemo")
    let directoryContents = try! FileManager.default.contentsOfDirectory(at: sharedContainerURL!, includingPropertiesForKeys: nil, options: [])
    print(directoryContents)
    let sourceUrl = sharedContainerURL?.appendingPathComponent(fileName as String)
    PHPhotoLibrary.shared().performChanges({
      PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: sourceUrl!)
    }) { (saved, error) in
      if saved {
        print("video saved")
      } else {
        print("\(error)")
      }
    }
    let activityViewController = UIActivityViewController(
      activityItems: [sourceUrl], applicationActivities: nil
    )
    DispatchQueue.main.async {
      self.bridge.uiManager.view(forReactTag: node)?.reactViewController()?.present(activityViewController, animated: true, completion: nil)
    }
  }
}




//pickerView.preferredExtension = RecordComponent.kBroadcastExtensionBundleId
