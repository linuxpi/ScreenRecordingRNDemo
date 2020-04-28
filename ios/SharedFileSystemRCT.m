//
//  SharedFileSystemRCT.m
//  ScreenRecordingDemo
//
//  Created by Varun Bansal on 22/02/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(SharedFileSystemRCT, NSObject)

RCT_EXTERN_METHOD(
                  getAllFiles: (RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject
                  )

@end
