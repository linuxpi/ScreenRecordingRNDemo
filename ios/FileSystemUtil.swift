//
//  FileSystemUtil.swift
//  ScreenRecordingDemo
//
//  Created by Varun Bansal on 21/02/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation


class FileSystemUtil
{
    internal class func createReplaysFolder()
    {
        // path to documents directory
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        if let documentDirectoryPath = documentDirectoryPath {
            // create the custom folder path
            let replayDirectoryPath = documentDirectoryPath.appending("/Replays")
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: replayDirectoryPath) {
                do {
                    try fileManager.createDirectory(atPath: replayDirectoryPath,
                                                    withIntermediateDirectories: false,
                                                    attributes: nil)
                } catch {
                    print("Error creating Replays folder in documents dir: \(error)")
                }
            }
        }
    }
    
    internal class func filePath(_ fileName: String) -> String
    {
        createReplaysFolder()
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as String
        let filePath : String = "\(documentsDirectory)/Replays/\(fileName).mp4"
        return filePath
    }
}

