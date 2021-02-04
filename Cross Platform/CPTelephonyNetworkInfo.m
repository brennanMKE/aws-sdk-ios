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

#import "CPTelephonyNetworkInfo.h"

#if TARGET_OS_IOS
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#endif

@interface CPTelephonyNetworkInfo ()

@property (readwrite, nonatomic) NSString * networkType;
@property (readwrite, nonatomic) NSString * carrier;
@property (readwrite, nonatomic) NSString * countryCode;
@property (readwrite, nonatomic) BOOL hasSimCard;

@end

@implementation CPTelephonyNetworkInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        #if TARGET_OS_WATCH
        self.networkType = @"";
        self.carrier = @"";
        self.hasSimCard = NO;
        #elif TARGET_OS_IOS
        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        self.networkType = [[[networkInfo serviceCurrentRadioAccessTechnology] allValues] firstObject];
        CTCarrier *cellularProvider = [[[networkInfo serviceSubscriberCellularProviders] allValues] firstObject];
        self.carrier = [cellularProvider carrierName];
        self.countryCode = cellularProvider.isoCountryCode;
        self.hasSimCard = self.countryCode != nil;
        #else
        self.networkType = @"";
        self.carrier = @"";
        self.hasSimCard = NO;
        #endif
    }
    return self;
}
@end
