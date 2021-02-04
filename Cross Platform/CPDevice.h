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

#import <Foundation/Foundation.h>
#if TARGET_OS_WATCH
#import <WatchKit/WatchKit.h>
#elif TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>
#elif TARGET_OS_OSX
#import <AppKit/AppKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

/// Device abstraction
NS_SWIFT_NAME(Device)
@interface CPDevice : NSObject

@property (class, readonly, nonatomic) CPDevice * currentDevice NS_SWIFT_NAME(current);

@property (readonly, nonatomic) NSString * name;
@property (readonly, nonatomic) NSString * model;
@property (readonly, nonatomic) NSString * systemVersion;
@property (readonly, nonatomic) NSString * systemName;
#if TARGET_OS_WATCH || TARGET_OS_IOS || TARGET_OS_TV
@property (readonly, nonatomic) NSUUID * identifierForVendor;
#endif

@end

NS_ASSUME_NONNULL_END
