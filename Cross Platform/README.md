#  Cross Platform

Apple Platforms include iOS, macOS, tvOS and watchOS as well as the Simulators. These are represented with preprocessor macros listed below.

* TARGET_OS_OSX
* TARGET_OS_IPHONE (TARGET_IPHONE_SIMULATOR)
* TARGET_OS_TV
* TARGET_OS_WATCH

All of the macros listed above fall under `TARGET_OS_MAC` while `TARGET_OS_WIN32` and `TARGET_OS_UNIX` are separate.

These preprocessor conditions can be used to include or exclude code during a build to isolate code which is only meant to build on specific platforms. One example is `UIDevice` which is only defined with `UIKit` for iOS and tvOS but absent from macOS and watchOS. Properties for `UIDevice` can be abstraced to provide a reasonable value for macOS and watchOS so that all platforms can be supported instead of limiting a code base to just iOS or tvOS.

Generally the import statements below will allow for importing the platform-specific frameworks which will be used.

```objc
#import <Foundation/Foundation.h>
#if TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>
#elif TARGET_OS_WATCH
#import <WatchKit/WatchKit.h>
#elif TARGET_OS_OSX
#import <AppKit/AppKit.h>
#endif
```

Since `UIKit` can be used with `iOS` and `tvOS` it can be imported with these platforms. Then `WatchKit` is specific to `watchOS` and `AppKit` is for `macOS`.

## Build Settings

In an `.xcconfig` file the following settings will set up a build target which builds for all of the supported platforms with specific versions for deployment targets and linking for platform-specific frameworks. Associate this `.xcconfig` file with the build target's configurations for `Debug` and `Release`.

```sh
SUPPORTED_PLATFORMS = macosx iphoneos iphonesimulator appletvos appletvsimulator watchos watchsimulator

IPHONEOS_DEPLOYMENT_TARGET = 13.1
MACOSX_DEPLOYMENT_TARGET = 10.15
TVOS_DEPLOYMENT_TARGET = 13.1
WATCHOS_DEPLOYMENT_TARGET = 6.2

OTHER_LDFLAGS[sdk=macosx*]           = $(inherited) '-framework' 'Cocoa' '-framework' 'AppKit'
OTHER_LDFLAGS[sdk=iphoneos*]         = $(inherited) '-framework' 'UIKit' '-framework' 'CoreTelephony'
OTHER_LDFLAGS[sdk=iphonesimulator*]  = $(inherited) '-framework' 'UIKit' '-framework' 'CoreTelephony'
OTHER_LDFLAGS[sdk=appletvos*]        = $(inherited) '-framework' 'UIKit'
OTHER_LDFLAGS[sdk=watchos*]          = $(inherited) '-framework' 'WatchKit'
```

See `TargetConditionals.h` for more details. An except is copied below.

```
 TARGET_OS_*
 These conditionals specify in which Operating System the generated code will
 run.  Indention is used to show which conditionals are evolutionary subclasses.

 The MAC/WIN32/UNIX conditionals are mutually exclusive.
 The IOS/TV/WATCH conditionals are mutually exclusive.

     TARGET_OS_WIN32           - Generated code will run under 32-bit Windows
     TARGET_OS_UNIX            - Generated code will run under some Unix (not OSX)
     TARGET_OS_MAC             - Generated code will run under Mac OS X variant
        TARGET_OS_OSX          - Generated code will run under OS X devices
        TARGET_OS_IPHONE          - Generated code for firmware, devices, or simulator
           TARGET_OS_IOS             - Generated code will run under iOS
           TARGET_OS_TV              - Generated code will run under Apple TV OS
           TARGET_OS_WATCH           - Generated code will run under Apple Watch OS
           TARGET_OS_BRIDGE          - Generated code will run under Bridge devices
           TARGET_OS_MACCATALYST     - Generated code will run under macOS
        TARGET_OS_SIMULATOR      - Generated code will run under a simulator

     TARGET_OS_EMBEDDED        - DEPRECATED: Use TARGET_OS_IPHONE and/or TARGET_OS_SIMULATOR instead
     TARGET_IPHONE_SIMULATOR   - DEPRECATED: Same as TARGET_OS_SIMULATOR
     TARGET_OS_NANO            - DEPRECATED: Same as TARGET_OS_WATCH

   +---------------------------------------------------------------------+
   |                            TARGET_OS_MAC                            |
   | +---+ +-----------------------------------------------+ +---------+ |
   | |   | |               TARGET_OS_IPHONE                | |         | |
   | |   | | +---------------+ +----+ +-------+ +--------+ | |         | |
   | |   | | |      IOS      | |    | |       | |        | | |         | |
   | |OSX| | |+-------------+| | TV | | WATCH | | BRIDGE | | |DRIVERKIT| |
   | |   | | || MACCATALYST || |    | |       | |        | | |         | |
   | |   | | |+-------------+| |    | |       | |        | | |         | |
   | |   | | +---------------+ +----+ +-------+ +--------+ | |         | |
   | +---+ +-----------------------------------------------+ +---------+ |
   +---------------------------------------------------------------------+
```

* [Building a Cross-Platform Framework] (Dave DeLong)

---
[Building a Cross-Platform Framework]: https://davedelong.com/blog/2018/11/15/building-a-crossplatform-framework/
