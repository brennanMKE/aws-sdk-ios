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

#import "CPDevice.h"

@interface CPDevice ()

@property (readwrite, copy, nonatomic) NSString * name;
@property (readwrite, copy, nonatomic) NSString * model;
@property (readwrite, copy, nonatomic) NSString * systemVersion;
@property (readwrite, copy, nonatomic) NSString * systemName;
#if TARGET_OS_WATCH || TARGET_OS_IOS || TARGET_OS_TV
@property (readwrite, copy, nonatomic) NSUUID * identifierForVendor;
#endif

@end

@implementation CPDevice

- (instancetype)init {
    self = [super init];
    if (self) {
        #if TARGET_OS_WATCH
        WKInterfaceDevice *device = [WKInterfaceDevice currentDevice];
        self.name = [device name];
        self.model = [device model];
        self.systemVersion = [device systemVersion];
        self.systemName = [device systemName];
        self.identifierForVendor = [device identifierForVendor];
        #elif TARGET_OS_IOS || TARGET_OS_TV
        UIDevice *device = [UIDevice currentDevice];
        self.name = [device name];
        self.model = [device model];
        self.systemVersion = [device systemVersion];
        self.systemName = [device systemName];
        self.identifierForVendor = [device identifierForVendor];
        #else
        NSProcessInfo *processInfo = [NSProcessInfo processInfo];
        self.name = processInfo.hostName;
        self.model = @"Mac";
        self.systemVersion = processInfo.operatingSystemVersionString;
        self.systemName = @"Darwin";
        #endif
    }
    return self;
}

+ (CPDevice *)currentDevice {
    CPDevice * device = [[CPDevice alloc] init];
    return device;
}

@end
