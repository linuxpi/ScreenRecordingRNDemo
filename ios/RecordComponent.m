//
//  RecordComponent.m
//  ScreenRecordingDemo
//
//  Created by Varun Bansal on 21/02/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(RecordComponent, RCTViewManager)

RCT_EXTERN_METHOD(
                  showSaveView:(nonnull NSNumber *)node
                  fileName:(NSString *)
                  )

@end
