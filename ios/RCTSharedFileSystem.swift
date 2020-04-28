//
//  RCTSharedFileSystem.swift
//  ScreenRecordingDemo
//
//  Created by Varun Bansal on 22/02/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation


@objc(RCTSharedFileSystem)
class RCTSharedFileSystem: NSObject {
  
  var groupIdentifier = "group.org.reactjs.native.example.ScreenRecordingDemo.ScreenRecordingExt"
  
  @objc
  func getAllFiles(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) -> Void {
    let sharedContainerURL :URL?  = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier)
    let directoryContents = try! FileManager.default.contentsOfDirectory(at: sharedContainerURL!, includingPropertiesForKeys: [.contentModificationDateKey], options: [])
    let sortedContents = directoryContents.sorted { (a, b) -> Bool in
      let adate = (try? a.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast
      let bdate = (try? b.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast
      return adate > bdate
    }
    let finalData = sortedContents.map { (URL) -> Dictionary<String, Any> in
      return [
        "absolutePath": URL.absoluteString,
        "relativePath": URL.relativePath
      ]
    }
    resolve(finalData)
  }
}
