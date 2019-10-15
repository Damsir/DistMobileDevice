# Intro
DistMobileDevice 是一个屏幕设备适配库， 它能够以非常灵活的方式适配任何ios设备，包括iphone、ipad、ipod touch 等等
使用方式非常简单，

# Usage
```objc
#define Device_in(...) [DistMobileDevice isOneOfThem: __VA_ARGS__, nil]
#define Device_is(is) [DistMobileDevice isOneOfThem:is, nil]
// device type
#define iPhone Device_is(iPhone_serial) || (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define iPad Device_is(iPad_serial) || (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define iPod Device_is(iPod_serial)
#define Simulator Device_is(simulator)
// serial
#define iPhone4_serial Device_in(iPhone4,iPhone4s)
#define iPhone5_serial Device_in(iPhone5,iPhone5c,iPhone5s)
#define iPhone6_serial Device_in(iPhone6,iPhone6s,iPhone6p,iPhone6sp)
#define iPhone7_serial Device_in(iPhone7,iPhone7p)
#define iPhone8_serial Device_in(iPhone8,iPhone8p)
#define iPhoneX_serial Device_in(iPhoneX,iPhoneXR,iPhoneXS,iPhoneXSMax)
#define iPhone11_serial DDevice_in(iPhone11,iPhone11Pro,iPhone11ProMax)
#define iPhoneHair_serial (iPhoneX_serial || iPhone11_serial) //带刘海
#define iPad1_serial Device_in(iPad1,iPad1_3G)
#define iPad2_serial Device_in(iPad2WiFi,iPad2,iPad2CDMA)
#define iPad3_serial Device_in(iPad3,ipad3WiFi,ipad3GSM_CDMA)
#define iPad4_serial Device_in(iPad4,ipad4WiFi,iPad4GSM_CDMA)
#define iPad5_serial Device_in(iPad5WiFi,iPad5Cellular)
#define iPad6_serial Device_in(iPad6WiFi,iPad6Cellular)
#define iPadMini_serial Device_in(iPadMiniWiFi,iPadMini,iPadMiniGSM_CDMA)
#define iPadMini2_serial Device_in(iPadMini2WiFi,iPadMini2Cellular,iPadMini2)
#define iPadMini4_serial Device_in(iPadMini4WiFi,iPadMini4LTE)
#define iPadAir_serial Device_in(iPadAirWiFi,iPadAirCellular)
#define iPadPro_serial Device_in(iPadPro9_7,iPadPro12_9,iPadPro10_5,iPadPro11)
// size
#define Device_Screen_320x568 Device_in(iPhone5,iPhone5c,iPhone5s,iPhoneSE)
#define Device_Screen_375x667 Device_in(iPhone6,iPhone6s,iPhone7,iPhone8)
#define Device_Screen_414x736 Device_in(iPhone6p,iPhone6sp,iPhone7p,iPhone8p)
#define Device_Screen_375x812 Device_in(iPhoneX,iPhoneXS)
#define Device_Screen_414x896 Device_in(iPhoneXSMax,iPhoneXR)

if (Device_Screen_414x896) {
        ····
}

```
使用以上宏定义可以判断系列型号类型的设备、屏幕系列的设备，也可以通过以下方式判断任何设备
```objc
#define Device_in(...) [DistMobileDevice isOneOfThem: __VA_ARGS__, nil]
#define Device_is(is) [DistMobileDevice isOneOfThem:is,nil]

Device_in(iPhone4,iPhone7);

```
如果你不想使用宏定义，可以通过
```objc
+ (BOOL)isOneOfThem:(DistMobileDeviceType)firstType,...NS_REQUIRES_NIL_TERMINATION;

[DistMobileDevice isOneOfThem:iphone4,iPhone7, nil];
```
DistMobileDevice 提供通用匹配功能，如果你在对iphone和ipad进行同时同时开发，你可以对通用设备进行匹配
```objc
Device_in(iPhone)/Device_is(iPhone) // 判断是否是iPhone
Device_in(iPad)/Device_is(iPad) // 判断是否是iPad
Device_in(iPod)/Device_is(iPod) // 判断是否是iPod touch
```

对于模拟器调试，由于模拟器架构为 x86_64或者i385，调试目标设备时，需要将模拟器设为目标设备，例如在启动模拟器iphone8p之前，你需要在app启动时调用以下代码：
```objc
[DistMobileDevice simulatorType:iPhone8p];
```

# Installation
推荐使用 CocoaPods
```
pod 'DistMobileDevice'
```
也可以拷贝以下文件至工程：
```
DistMobileDevice.h
DistMobileDevice.m
```

# Version
1.0.0

ios 8.0

新增 iphone 11 系列

## License

DistMobileDevice is released under the MIT license. See [LICENSE](https://github.com/Diasir/DistMobileDevice/raw/master/LICENSE) for details.

