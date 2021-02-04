#import "AWSCognitoIdentityASF.h"

#import <Foundation/Foundation.h>
#if TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>
#elif TARGET_OS_WATCH
#import <WatchKit/WatchKit.h>
#elif TARGET_OS_OSX
#import <AppKit/AppKit.h>
#endif
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <sys/utsname.h>
#import <CommonCrypto/CommonHMAC.h>

#import "CPDevice.h"
#import "CPScreen.h"
#import "CPTelephonyNetworkInfo.h"

@interface AWSCognitoIdentityASF()
+ (NSString *) dashIfNil: (NSString *) str;
@end

@implementation AWSCognitoIdentityASF

static NSString *const AWSCognitoIdentityAppName = @"ApplicationName";
static NSString *const AWSCognitoIdentityAppTargetSDK = @"ApplicationTargetSdk";
static NSString *const AWSCognitoIdentityAppVersion = @"ApplicationVersion";
static NSString *const AWSCognitoIdentityBootloader = @"Bootloader"; //N/A
static NSString *const AWSCognitoIdentityBrand = @"DeviceBrand"; //N/A
static NSString *const AWSCognitoIdentityDeviceFingerprint = @"DeviceFingerprint"; //N/A
static NSString *const AWSCognitoIdentityHardware = @"DeviceHardware";
static NSString *const AWSCognitoIdentityManufacturer = @"DeviceManufacturer";  //Always Apple
static NSString *const AWSCognitoIdentityDeviceName = @"DeviceName";
static NSString *const AWSCognitoIdentityProduct = @"Product";
static NSString *const AWSCognitoIdentityBuildType = @"BuildType";
static NSString *const AWSCognitoIdentityReleaseVersion = @"DeviceOsReleaseVersion";
static NSString *const AWSCognitoIdentitySdkVersion = @"DeviceSdkVersion";
static NSString *const AWSCognitoIdentityDeviceId = @"DeviceId";
static NSString *const AWSCognitoIdentityThirdPartyDeviceId = @"ThirdPartyDeviceId";
static NSString *const AWSCognitoIdentityPlatform = @"Platform";
static NSString *const AWSCognitoIdentityTimezone = @"ClientTimezone";
static NSString *const AWSCognitoIdentityDeviceHeight = @"ScreenHeightPixels";
static NSString *const AWSCognitoIdentityDeviceWidth = @"ScreenWidthPixels";
static NSString *const AWSCognitoIdentityDeviceLanguage = @"DeviceLanguage";
static NSString *const AWSCognitoIdentityIsNetworkRoaming = @"IsNetworkRoaming"; //N/A
static NSString *const AWSCognitoIdentityCarrier = @"Carrier";
static NSString *const AWSCognitoIdentityNetworkType = @"NetworkType";
static NSString *const AWSCognitoIdentityPhoneType = @"PhoneType";
static NSString *const AWSCognitoIdentityHasSimCard = @"HasSimCard";
static NSString *const AWSCognitoIdentitySimCountryIso = @"SimCountry"; //N/A
static NSString *const AWSCognitoIdentitySimOperator = @"SimOperator"; //N/A
static NSString *const AWSCognitoIdentityASFVersion= @"IOS20171114";

+ (NSString *) userContextData: (int) minTarget build: (NSString *) build userPoolId: (NSString*) userPoolId username: (NSString *) username deviceId: (NSString * _Nullable) deviceId userPoolClientId: (NSString *) userPoolClientId {
    CPDevice *device = [CPDevice currentDevice];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *bundleIdentifier = [bundle bundleIdentifier];
    NSString *buildVersion = [bundle objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    NSString *bundleVersion = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    CGRect bounds = [[CPScreen mainScreen] nativeBounds];
    CGFloat screenWidth = bounds.size.width;
    CGFloat screenHeight = bounds.size.height;
    
    NSDateFormatter *localTimeZoneFormatter = [NSDateFormatter new];
    localTimeZoneFormatter.timeZone = [NSTimeZone localTimeZone];
    localTimeZoneFormatter.dateFormat = @"Z";
    NSString *localTimeZoneOffset = [localTimeZoneFormatter stringFromDate:[NSDate date]];
    
    NSString *hourOffset = [localTimeZoneOffset substringToIndex:[localTimeZoneOffset length] - 2];
    NSString *minuteOffset = [localTimeZoneOffset substringFromIndex:[localTimeZoneOffset length] - 2];
    NSString *timezoneOffset = [NSString stringWithFormat:@"%@:%@",hourOffset,minuteOffset];
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    CPTelephonyNetworkInfo *networkInfo = [[CPTelephonyNetworkInfo alloc] init];
    NSString *fingerprint = [NSString stringWithFormat:@"Apple/%@/%@/-:%@/-/-:-/%@",
                                                        [AWSCognitoIdentityASF dashIfNil:[device model]],
                                                        [AWSCognitoIdentityASF dashIfNil:[AWSCognitoIdentityASF deviceName]],
                                                        [AWSCognitoIdentityASF dashIfNil:[device systemVersion]],
                                                        [AWSCognitoIdentityASF dashIfNil:build]];
    
    
    NSString * minTargetString = [NSString stringWithFormat:@"%i", minTarget];
    
    NSMutableDictionary * contextData= [NSMutableDictionary new];
    [AWSCognitoIdentityASF addIfNotNil: contextData key:AWSCognitoIdentityAppName value:bundleIdentifier];
    [AWSCognitoIdentityASF addIfNotNil: contextData key:AWSCognitoIdentityAppTargetSDK value: minTargetString];
    [AWSCognitoIdentityASF addIfNotNil: contextData key:AWSCognitoIdentityAppVersion value:[NSString stringWithFormat:@"%@-%@",bundleVersion,buildVersion]];
    [AWSCognitoIdentityASF addIfNotNil: contextData key:AWSCognitoIdentityDeviceName value:[device name]];
    [AWSCognitoIdentityASF addIfNotNil: contextData key:AWSCognitoIdentityPhoneType value:[AWSCognitoIdentityASF deviceName]];
    #if TARGET_OS_IPHONE
    NSString *vendor = device.identifierForVendor.UUIDString;
    #else
    NSString *vendor = @"";
    #endif
    [AWSCognitoIdentityASF addIfNotNil: contextData key:AWSCognitoIdentityThirdPartyDeviceId value:vendor];
    [AWSCognitoIdentityASF addIfNotNil: contextData key:AWSCognitoIdentityDeviceId value: ((deviceId == nil)? vendor : deviceId)]; //TODO
    [AWSCognitoIdentityASF addIfNotNil: contextData key:AWSCognitoIdentityReleaseVersion value: [device systemVersion]];
    [AWSCognitoIdentityASF addIfNotNil: contextData key:AWSCognitoIdentityPlatform value: [device systemName]];
    [AWSCognitoIdentityASF addIfNotNil: contextData key:AWSCognitoIdentityBuildType value: build];
    [AWSCognitoIdentityASF addIfNotNil: contextData key:AWSCognitoIdentityTimezone value: timezoneOffset];
    [AWSCognitoIdentityASF addIfNotNil: contextData key:AWSCognitoIdentityDeviceHeight value: [NSString stringWithFormat:@"%.0f",screenHeight]];
    [AWSCognitoIdentityASF addIfNotNil: contextData key:AWSCognitoIdentityDeviceWidth value: [NSString stringWithFormat:@"%.0f",screenWidth]];
    [AWSCognitoIdentityASF addIfNotNil: contextData key:AWSCognitoIdentityDeviceLanguage value: locale];
    [AWSCognitoIdentityASF addIfNotNil: contextData key:AWSCognitoIdentityCarrier value: networkInfo.carrier];
    [AWSCognitoIdentityASF addIfNotNil: contextData key:AWSCognitoIdentityNetworkType value: networkInfo.networkType];
    [AWSCognitoIdentityASF addIfNotNil: contextData key:AWSCognitoIdentityHasSimCard value:networkInfo.hasSimCard ? @"true" : @"false"];
    
    [AWSCognitoIdentityASF addIfNotNil: contextData key:AWSCognitoIdentityDeviceFingerprint value:fingerprint];
    
    if(username == nil){
        username = @"unknown";
    }
    
    NSDictionary * payload =  @{
                                @"contextData": contextData,
                                @"username":username,
                                @"userPoolId": userPoolId,
                                @"timestamp" : [NSString stringWithFormat:@"%lli", [@(floor([[NSDate date] timeIntervalSince1970] * 1000)) longLongValue]]
                                };
    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payload
                                                       options:0
                                                         error:&error];
    if(error){
        return nil;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary * result = @{
                              @"payload": jsonString,
                              @"version": AWSCognitoIdentityASFVersion,
                              @"signature": [AWSCognitoIdentityASF calculateSecretHash: jsonString clientId:userPoolClientId]
                              };
    
    jsonData = [NSJSONSerialization dataWithJSONObject:result
                                               options:0
                                                 error:&error];
    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if(error){
        return nil;
    }
    
    NSData *data = [jsonString
                    dataUsingEncoding:NSUTF8StringEncoding];
    
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
    
    return base64Encoded;
}


+ (NSString*) deviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

+ (NSString *) dashIfNil: (NSString *) str
{
    return (str == nil ? @"-" : ([str stringByReplacingOccurrencesOfString:@" " withString:@"_"]));
}

+ (NSString *) calculateSecretHash: (NSString*) json clientId: (NSString *) clientId
{
    const char *cKey  = [clientId cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [[AWSCognitoIdentityASFVersion stringByAppendingString:json] cStringUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC
                                          length:CC_SHA256_DIGEST_LENGTH];
    
    return [HMAC base64EncodedStringWithOptions:kNilOptions];
}

+ (void) addIfNotNil: (NSMutableDictionary *) dict key:(NSString *) key value:(NSString * _Nullable) value {
    if(value != nil){
        [dict setValue:value forKey:key];
    }
}

@end
