//
// Copyright 2010-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License").
// You may not use this file except in compliance with the License.
// A copy of the License is located at
//
// http://aws.amazon.com/apache2.0
//
// or in the "license" file accompanying this file. This file is distributed
// on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
// express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//

#import "CPScreen.h"

#if TARGET_OS_OSX
#import <AppKit/AppKit.h>
#endif

@interface CPScreen ()

@property (readwrite, nonatomic) CGRect bounds;
@property (readwrite, nonatomic) CGRect nativeBounds;
@property (readwrite, nonatomic) CGFloat scale;
@property (readwrite, nonatomic) CGFloat nativeScale;

@end

@implementation CPScreen

- (instancetype)init {
    self = [super init];
    if (self) {
        #if TARGET_OS_WATCH
        self.bounds = CGRectZero;
        self.nativeBounds = CGRectZero;
        self.scale = 1.0;
        self.nativeScale = 1.0;
        #elif TARGET_OS_IOS || TARGET_OS_TV
        UIScreen *screen = [UIScreen mainScreen];
        self.bounds = screen.bounds;
        self.nativeBounds = screen.nativeBounds;
        self.scale = screen.scale;
        self.nativeScale = screen.nativeScale;
        #elif TARGET_OS_OSX
        NSScreen *screen = [NSScreen mainScreen];
        self.bounds = screen.visibleFrame;
        self.nativeBounds = screen.visibleFrame;
        self.scale = 1.0;
        self.nativeScale = 1.0;
        #endif
        
    }
    return self;
}

+ (CPScreen *)mainScreen {
    CPScreen *mainScreen = [[CPScreen alloc] init];
    return mainScreen;
}

@end
