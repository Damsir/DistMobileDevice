//
//  DistMobileDevice.h
//
//  Created by 吴定如 on 2018/10/10.
//  Copyright © 2018年 Dist. All rights reserved.
//
//  @2019.10.15 新增iPhone 11系列
//  @2020.03.27 新增设备UDID等

#import <Foundation/Foundation.h>

/**
 *  设备相关的信息库
 */

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

// 为了方便使用，将不为枚举添加前缀，请使用前注意没有冲突问题
typedef NS_ENUM(NSUInteger, DistMobileDeviceType) {
    mobileDeviceUnkown = 0,
    
    //==>iPhone
    iPhone_serial,//1
    iPhone4,iPhone4s,
    iPhone5,iPhone5c,iPhone5s,
    iPhone6,iPhone6s,
    iPhone6p,iPhone6sp,
    iPhoneSE,
    iPhone7,iPhone7p,
    iPhone8,iPhone8p,
    iPhoneX,
    iPhoneXR,iPhoneXS,iPhoneXSMax,
    iPhone11,iPhone11Pro,iPhone11ProMax,
    //==>iPod
    iPod_serial,//23
    iPod1G,iPod2G,iPod3G,iPod4G,iPod5Gen,iPod6Gen,
    //==>ipad
    iPad_serial,//30
    iPad1,iPad1_3G,
    iPad2WiFi,iPad2,iPad2CDMA,
    iPadMiniWiFi,iPadMini,iPadMiniGSM_CDMA,
    iPad3,ipad3WiFi,ipad3GSM_CDMA,
    iPad4,ipad4WiFi,iPad4GSM_CDMA,
    iPadAirWiFi,iPadAirCellular,
    iPadMini2WiFi,iPadMini2Cellular,iPadMini2,
    iPadMini3,
    iPadMini4WiFi,iPadMini4LTE,
    iPadAir2,
    iPadPro9_7,iPadPro12_9,iPadPro10_5,
    iPad5WiFi,iPad5Cellular,
    iPad6WiFi,iPad6Cellular,
    iPadPro11,
    iPadAir3,
    iPadMini5,
    //==>simulator
    simulator,//64
    simulatori386,simulatorx86_64,
    
    mobileDeviceTypeEnd//哨兵
};

typedef NS_ENUM(NSInteger, DistMobileDeviceNetworkType){
    none,
    _2G,_3G,_4G,
    LTE,WiFi
};

@interface DistMobileDevice : NSObject

/**
 *  因为模拟器运行所识别的型号为模拟器，可设置模拟器代替型号，以方便模拟器调试。
 *  设置为 simulator 则不做任何代替
 *  不要赋值为 iPhone等通用类型、mobileDeviceUnkown、mobileDeviceTypeEnd
 */
+ (void)simulatorType:(DistMobileDeviceType)type;
/**
 *  获取和判断移动设备的型号
 */
+ (DistMobileDeviceType)deviceType;
+ (BOOL)isOneOfThem:(DistMobileDeviceType)firstType,...NS_REQUIRES_NIL_TERMINATION;
+ (NSString *)platform;// 获取当前移动设备型号的字符串
/**
 *  获取和判断当前移动设备的网络类型
 */
+ (BOOL)isUsing:(DistMobileDeviceNetworkType)networkType;
+ (DistMobileDeviceNetworkType)networkType;

/** 判断设备是否越狱 */
+ (BOOL)isJailBroken;
/** 获取当前使用的 WIFI 的名称 */
+ (NSString *)WiFiSSID;

/** 获取设备当前网络IP地址 */
+ (NSString *)deviceIPAddress:(BOOL)preferIPv4;

/** 设备名称（用户自己设置的名字） */
+ (NSString *)deviceUserName;

/** 设备系统版本 (e.g. @"12.1.4") */
+ (NSString *)deviceSystemVersion;

/** 设备型号 (iPad or iPhone)  */
+ (NSString *)deviceModel;

/** 设备当前运行的系统 (e.g. @"iOS") */
+ (NSString *)deviceSystemName;

/**
 *  设备唯一识别码
 *  获取一个保存在keyChain中的IDFV(uuid), 如果不存在, 就创建一个, 然后返回
 *  method             deviceUDID, Requires iOS6.0 and later
 *  abstract           Obtain UDID(Unique Device Identity). If it already exits in keychain, return the exit one; otherwise generate a new one and store it into the keychain then return.
 *  discussion         Use 'identifierForVendor + keychain' to make sure UDID consistency even if the App has been removed or reinstalled.
 *  param              NULL
 *  param result       return UDID String
 */
+ (NSString *)deviceUDID;

@end
