//
//  DistMobileDevice.m
//
//  Created by 吴定如 on 2018/10/10.
//  Copyright © 2018年 Dist. All rights reserved.
//
//  型号列表：https://www.theiphonewiki.com/wiki/Models

#import "DistMobileDevice.h"
#import <UIKit/UIKit.h>
#import <sys/sysctl.h>
#import "SystemConfiguration/CaptiveNetwork.h"
// IP
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>

static NSUInteger DistSimulatorType = simulator;
static NSDictionary *deviceMap;

@implementation DistMobileDevice

+ (NSDictionary *)deviceMap {
    return @{
             // iPhone
             @"iPhone3,1":@(iPhone4),@"iPhone3,2":@(iPhone4),@"iPhone3,3":@(iPhone4),
             @"iPhone4,1":@(iPhone4s),
             @"iPhone5,1":@(iPhone5),@"iPhone5,2":@(iPhone5),
             @"iPhone5,3":@(iPhone5c),@"iPhone5,4":@(iPhone5c),
             @"iPhone6,1":@(iPhone5s),@"iPhone6,2":@(iPhone5s),
             @"iPhone7,1":@(iPhone6p),
             @"iPhone7,2":@(iPhone6),
             @"iPhone8,1":@(iPhone6s),
             @"iPhone8,2":@(iPhone6sp),
             @"iPhone8,4":@(iPhoneSE),@"iPhone12,8":@(iPhoneSE2),
             @"iPhone9,1":@(iPhone7),@"iPhone9,3":@(iPhone7),
             @"iPhone9,2":@(iPhone7p),@"iPhone9,4":@(iPhone7p),
             @"iPhone10,1":@(iPhone8),@"iPhone10,4":@(iPhone8),
             @"iPhone10,2":@(iPhone8p),@"iPhone10,5":@(iPhone8p),
             @"iPhone10,3":@(iPhoneX),@"iPhone10,6":@(iPhoneX),
             @"iPhone11,2":@(iPhoneXS),
             @"iPhone11,4":@(iPhoneXSMax),@"iPhone11,6":@(iPhoneXSMax),
             @"iPhone11,8":@(iPhoneXR),
             @"iPhone12,1":@(iPhone11),@"iPhone12,3":@(iPhone11Pro),@"iPhone12,5":@(iPhone11ProMax),
             @"iPhone13,1":@(iPhone12Mini),@"iPhone13,2":@(iPhone12),@"iPhone13,3":@(iPhone12Pro),@"iPhone13,4":@(iPhone12ProMax),
             // iPod
             @"iPod1,1":@(iPod1G),@"iPod2,1":@(iPod2G),
             @"iPod3,1":@(iPod3G),@"iPod4,1":@(iPod4G),
             @"iPod5,1":@(iPod5Gen),
             @"iPod7,1":@(iPod6Gen),
             // iPad
             @"iPad1,1":@(iPad1),@"iPad1,2":@(iPad1_3G),
             @"iPad2,1":@(iPad2WiFi),@"iPad2,2":@(iPad2),@"iPad2,3":@(iPad2CDMA),@"iPad2,4":@(iPad2),
             @"iPad2,5":@(iPadMiniWiFi),@"iPad2,6":@(iPadMini),@"iPad2,7":@(iPadMiniGSM_CDMA),
             @"iPad3,1":@(ipad3WiFi),@"iPad3,2":@(ipad3GSM_CDMA),@"iPad3,3":@(iPad3),
             @"iPad3,4":@(ipad4WiFi),@"iPad3,5":@(iPad4),@"iPad3,6":@(iPad4GSM_CDMA),
             @"iPad4,1":@(iPadAirWiFi),@"iPad4,2":@(iPadAirCellular),
             @"iPad4,4":@(iPadMini2WiFi),@"iPad4,5":@(iPadMini2Cellular),@"iPad4,6":@(iPadMini2),
             @"iPad4,7":@(iPadMini3),@"iPad4,8":@(iPadMini3),@"iPad4,9":@(iPadMini3),
             @"iPad5,1":@(iPadMini4WiFi),@"iPad5,2":@(iPadMini4LTE),
             @"iPad5,3":@(iPadAir2),@"iPad5,4":@(iPadAir2),
             @"iPad6,3":@(iPadPro9_7),@"iPad6,4":@(iPadPro9_7),
             @"iPad6,7":@(iPadPro12_9),@"iPad6,8":@(iPadPro12_9),
             @"iPad6,11":@(iPad5WiFi),@"iPad6,12":@(iPad5Cellular),
             @"iPad7,1":@(iPadPro12_9),@"iPad7,2":@(iPadPro12_9),
             @"iPad7,3":@(iPadPro10_5),@"iPad7,4":@(iPadPro10_5),
             @"iPad7,3":@(iPad6WiFi),@"iPad7,4":@(iPad6Cellular),
             @"iPad8,1":@(iPadPro11),@"iPad8,2":@(iPadPro11),@"iPad8,3":@(iPadPro11),@"iPad8,4":@(iPadPro11),
             @"iPad8,5":@(iPadPro12_9),@"iPad8,6":@(iPadPro12_9),@"iPad8,7":@(iPadPro12_9),@"iPad8,8":@(iPadPro12_9),
             @"iPad11,1":@(iPadMini5),@"iPad11,2":@(iPadMini5),
             @"iPad11,3":@(iPadAir3),@"iPad11,4":@(iPadAir3),
             // simulator
             @"i386":@(simulatori386),@"x86_64":@(simulatorx86_64),
             };
}

+ (void)simulatorType:(DistMobileDeviceType)type {
    DistSimulatorType = type;
}
/*
 *  返回通用类型，可用于模糊查询
 */
+ (NSArray *)commonTypes {
    return @[@(iPhone_serial),@(iPod_serial),@(iPad_serial),@(simulator)];
}

+ (DistMobileDeviceType)deviceType {
    
    NSUInteger type = mobileDeviceUnkown;
    NSString *platform = [self platform];
    NSNumber *numObj = [self deviceMap][platform];
    
    if (numObj)
        type = numObj.integerValue;
    
    return type;
}

+ (BOOL)isOneOfThem:(DistMobileDeviceType)firstType, ... {
    
    DistMobileDeviceType deviceType = [self deviceType];
    
    if ((deviceType == simulatori386 || deviceType == simulatorx86_64)
        && DistSimulatorType != simulator) {
        deviceType = DistSimulatorType;
    }
    
    va_list types;
    __block BOOL isEqual = NO;
    
    va_start(types, firstType);
    [self emurate:firstType list:types
           action:^(DistMobileDeviceType type,BOOL *_break) {
               *_break = isEqual = (deviceType == type);
           }];
    // 找不到相应的移动设备类型，有可能是调用者传入了通用类型（iPhone/iPad之类）
    if (!isEqual) {
        va_start(types, firstType);
        [self emurate:firstType list:types
               action:^(DistMobileDeviceType type, BOOL *_break) {
                   
                   if ([[self commonTypes] containsObject:@(type)] &&
                       [self type:deviceType isKindOfCommonType:type])
                       *_break = isEqual = YES;
                   
               }];
    }
    va_end(types);
    return isEqual;
}

+ (NSString *)platform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}


+ (DistMobileDeviceNetworkType)networkType {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    NSNumber *number = (NSNumber*)[dataNetworkItemView valueForKey:@"dataNetworkType"];
    return [number intValue];
}

+ (BOOL)isUsing:(DistMobileDeviceNetworkType)networkType {
    if ([self networkType] == networkType)
        return YES;
    return NO;
}

+ (BOOL)isJailBroken {
    
    static BOOL __jailbreak;
    if (__jailbreak) return YES;
    
    static const char * __jb_apps[] = {
        "/Application/Cydia.app",
        "/Application/limera1n.app",
        "/Application/greenpois0n.app",
        "/Application/blackra1n.app",
        "/Application/blacksn0w.app",
        "/Application/redsn0w.app",
        NULL
    };
    
    for ( int i = 0; __jb_apps[i]; ++i ) {
        if ( [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:__jb_apps[i]]] ) {
            __jailbreak = YES;
            return YES;
        }
    }
    if ( [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] ) {
        __jailbreak = YES;
        return YES;
    }
    
    return NO;
}

+ (NSString *)WiFiSSID {
    
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    NSDictionary *info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    NSString *ssid = [NSString stringWithFormat:@"%@",[info objectForKey:@"SSID"]] ;
    return ssid;
}

#pragma mark - helpers

+ (BOOL)type:(DistMobileDeviceType)originType isKindOfCommonType:(DistMobileDeviceType)commonType {
    
    NSArray *commonTypes = [self commonTypes];
    if ([commonTypes containsObject:@(commonType)]) {
        NSUInteger begin = commonType;
        NSUInteger end = mobileDeviceTypeEnd;
        if(![[commonTypes lastObject] isEqual:@(commonType)]) {
            NSInteger nextIndex = [commonTypes indexOfObject:@(commonType)] + 1;
            NSNumber *numObj = [commonTypes objectAtIndex:nextIndex];
            end = numObj.integerValue;
        }
        
        if (originType > begin && originType < end)
            return YES;
    }
    
    return NO;
}

+ (void)emurate:(DistMobileDeviceType)firstType list:(va_list)types action:(void (^)(DistMobileDeviceType,BOOL *_break))action {
    
    if (!action) return;
    BOOL _break = NO;
    action(firstType,&_break);
    if (_break) return;
    
    DistMobileDeviceType nextType;
    while ((nextType = va_arg(types, DistMobileDeviceType))) {
        action(nextType,&_break);
        if (_break) return;
    }
}

#pragma mark - IP
#pragma mark - IPv4是32位地址长度
#pragma mark - IPv6是128位地址长度

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

// 获取设备当前网络IP地址
+ (NSString *)deviceIPAddress:(BOOL)preferIPv4 {
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    //    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         // 筛选出IP地址格式
         if ([self isValidatIP:address]) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result = [ipAddress substringWithRange:resultRange];
            // 输出结果
            NSLog(@"IP: %@",result);
            return YES;
        }
    }
    return NO;
}

+ (NSDictionary *)getIPAddresses {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

#pragma mark - Device Info

static NSString *kUDIDValue = nil;
static NSString *const kKeychainUDIDItemIdentifier  = @"UDID";   /* Replace with your own UDID identifier */
static NSString *const kKeychainUDIDItemServiceName = @"com.dist.SHUDID"; /* Replace with your own service name, usually you can use your App Bundle ID */

/**< 设备名称（用户自己设置的名字） */
+ (NSString *)deviceUserName {
    return [[UIDevice currentDevice] name];
}

/**< 设备系统版本  */
+ (NSString *)deviceSystemVersion {
    return [[UIDevice currentDevice] systemVersion];
}

/**< 设备型号 */
+ (NSString *)deviceModel {
    return [[UIDevice currentDevice] model];
}

/**< 设备当前运行的系统  */
+ (NSString *)deviceSystemName {
    return [[UIDevice currentDevice] systemName];
}

/** 设备名称、型号 (e.g. @"iPhone 6s") */
+ (NSString *)deviceName {
    static NSString *deviceName = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *platform = [self platform];
        deviceName = [self deviceStringMap][platform];
        if (deviceName.length == 0) {
            deviceName = @"iPhone";
        }
    });
    return deviceName;
}

+ (NSDictionary *)deviceStringMap {
    return @{
             // iPhone
             @"iPhone3,1":@"iPhone4",@"iPhone3,2":@"iPhone4",@"iPhone3,3":@"iPhone4",
             @"iPhone4,1":@"iPhone4s",
             @"iPhone5,1":@"iPhone5",@"iPhone5,2":@"iPhone5",
             @"iPhone5,3":@"iPhone5c",@"iPhone5,4":@"iPhone5c",
             @"iPhone6,1":@"iPhone5s",@"iPhone6,2":@"iPhone5s",
             @"iPhone7,1":@"iPhone6p",
             @"iPhone7,2":@"iPhone6",
             @"iPhone8,1":@"iPhone6s",
             @"iPhone8,2":@"iPhone6sp",
             @"iPhone8,4":@"iPhoneSE",
             @"iPhone9,1":@"iPhone7",@"iPhone9,3":@"iPhone7",
             @"iPhone9,2":@"iPhone7p",@"iPhone9,4":@"iPhone7p",
             @"iPhone10,1":@"iPhone8",@"iPhone10,4":@"iPhone8",
             @"iPhone10,2":@"iPhone8p",@"iPhone10,5":@"iPhone8p",
             @"iPhone10,3":@"iPhoneX",@"iPhone10,6":@"iPhoneX",
             @"iPhone11,2":@"iPhoneXS",
             @"iPhone11,4":@"iPhoneXSMax",@"iPhone11,6":@"iPhoneXSMax",
             @"iPhone11,8":@"iPhoneXR",
             @"iPhone12,1":@"iPhone11",@"iPhone12,3":@"iPhone11Pro",@"iPhone12,5":@"iPhone11ProMax",
             @"iPhone13,1":@"iPhone12Mini",@"iPhone13,2":@"iPhone12",@"iPhone13,3":@"iPhone12Pro",@"iPhone13,4":@"iPhone12ProMax",
             // iPod
             @"iPod1,1":@"iPod1G",@"iPod2,1":@"iPod2G",
             @"iPod3,1":@"iPod3G",@"iPod4,1":@"iPod4G",
             @"iPod5,1":@"iPod5Gen",
             @"iPod7,1":@"iPod6Gen",
             // iPad
             @"iPad1,1":@"iPad1",@"iPad1,2":@"iPad1_3G",
             @"iPad2,1":@"iPad2WiFi",@"iPad2,2":@"iPad2",@"iPad2,3":@"iPad2CDMA",@"iPad2,4":@"iPad2",
             @"iPad2,5":@"iPadMiniWiFi",@"iPad2,6":@"iPadMini",@"iPad2,7":@"iPadMiniGSM_CDMA",
             @"iPad3,1":@"ipad3WiFi",@"iPad3,2":@"ipad3GSM_CDMA",@"iPad3,3":@"iPad3",
             @"iPad3,4":@"ipad4WiFi",@"iPad3,5":@"iPad4",@"iPad3,6":@"iPad4GSM_CDMA",
             @"iPad4,1":@"iPadAirWiFi",@"iPad4,2":@"iPadAirCellular",
             @"iPad4,4":@"iPadMini2WiFi",@"iPad4,5":@"iPadMini2Cellular",@"iPad4,6":@"iPadMini2",
             @"iPad4,7":@"iPadMini3",@"iPad4,8":@"iPadMini3",@"iPad4,9":@"iPadMini3",
             @"iPad5,1":@"iPadMini4WiFi",@"iPad5,2":@"iPadMini4LTE",
             @"iPad5,3":@"iPadAir2",@"iPad5,4":@"iPadAir2",
             @"iPad6,3":@"iPadPro9_7",@"iPad6,4":@"iPadPro9_7",
             @"iPad6,7":@"iPadPro12_9",@"iPad6,8":@"iPadPro12_9",
             @"iPad6,11":@"iPad5WiFi",@"iPad6,12":@"iPad5Cellular",
             @"iPad7,1":@"iPadPro12_9",@"iPad7,2":@"iPadPro12_9",
             @"iPad7,3":@"iPadPro10_5",@"iPad7,4":@"iPadPro10_5",
             @"iPad7,3":@"iPad6WiFi",@"iPad7,4":@"iPad6Cellular",
             @"iPad8,1":@"iPadPro11",@"iPad8,2":@"iPadPro11",@"iPad8,3":@"iPadPro11",@"iPad8,4":@"iPadPro11",
             @"iPad8,5":@"iPadPro12_9",@"iPad8,6":@"iPadPro12_9",@"iPad8,7":@"iPadPro12_9",@"iPad8,8":@"iPadPro12_9",
             @"iPad11,1":@"iPadMini5",@"iPad11,2":@"iPadMini5",
             @"iPad11,3":@"iPadAir3",@"iPad11,4":@"iPadAir3",
             // simulator
             @"i386":@"simulatori386",@"x86_64":@"simulatorx86_64",
             };
}

/**< 设备UDID  */
+ (NSString *)deviceUDID {
    if (kUDIDValue == nil) {
        @synchronized ([self class]) {
            NSData *itemData = [self selectKeychainItemWithIdentifier:kKeychainUDIDItemIdentifier serviceName:kKeychainUDIDItemServiceName];
            if (itemData) {
                kUDIDValue = [[NSString alloc] initWithData:itemData encoding:NSUTF8StringEncoding];
            } else {
                kUDIDValue = [self getIDFVString];
                [self insertKeychainItemWithValue:kUDIDValue identifier:kKeychainUDIDItemIdentifier serviceName:kKeychainUDIDItemServiceName];
            }
        }
    }
    
    return kUDIDValue;
}


#pragma mark - Extension Method: Insert / Delete / Update / Select
/**
 *  To find out if our UDID string already exists in the keychain (and what the value of the UDID string is), we use the `SecItemCopyMatching` function.
 */
+ (NSData *)selectKeychainItemWithIdentifier:(NSString *)identifier serviceName:(NSString *)serviceName {
    NSMutableDictionary *dicForSelect = [self baseAttributeDictionary:identifier serviceName:serviceName];
    
    /**
     *  key `kSecMatchLimit` is to limit the number of search results that returned. We are looking for a single entry so we set the attribute to `kSecMatchLimitOne`.
     */
    [dicForSelect setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    
    /**
     *  key `kSecReturnData` determines how the result is returned. Since we are expecting only a single attribute to be returned (the UDID string) we can set it to `kCFBooleanTrue`. This means we will get an NSData reference back that we can access directly.
     */
    [dicForSelect setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    /** !!!
     *  If we were storing and searching for a keychain item with multiple attributes (for example if we were storing an account name and password in the same keychain item) we would need to add the attribute `kSecReturnAttributes` and the result would be a dictionary of attributes.
     */
    
    NSData *result = nil;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)dicForSelect, (void *)&result);
    if (status == errSecSuccess) {
        // success
    } else {
        // failure
    }
    [self logAction:@"SecItemCopyMatching" status:(NSInteger)status];
    
    return result;
}

/**
 *  Inserting an keychain item is almost the same as the select function except that we need to set the value of the UDID string which we want to store. We use the `SecItemAdd` function.
 */
+ (BOOL)insertKeychainItemWithValue:(NSString *)value identifier:(NSString *)identifier serviceName:(NSString *)serviceName {
    NSMutableDictionary *dicForInsert = [self baseAttributeDictionary:identifier serviceName:serviceName];
    
    /**
     *  Add the key `kSecValueData` to the attribute dictionary to set the value of the keychain item(here means the UDID string), besides making sure encode the value string
     */
    NSData *dataForInsert = [value dataUsingEncoding:NSUTF8StringEncoding];
    [dicForInsert setObject:dataForInsert forKey:(id)kSecValueData];
    
    BOOL isSucceeded;
    OSStatus status = SecItemAdd((CFDictionaryRef)dicForInsert, NULL);
    if (status == errSecSuccess) {
        isSucceeded = YES;
    } else {
        isSucceeded = NO;
    }
    [self logAction:@"SecItemAdd" status:(NSInteger)status];
    
    return isSucceeded;
}

/**
 *  Updating a keychain item is similar to inserting an item except that a separate dictionary is used to contain the attributes to be updated. We use the `SecItemUpdate` function.
 */
+ (BOOL)updateKeychainItemWithValue:(NSString *)value identifier:(NSString *)identifier serviceName:(NSString *)serviceName {
    NSMutableDictionary *dicForSelect = [self baseAttributeDictionary:identifier serviceName:serviceName];
    
    NSMutableDictionary *dicForUpdate = [[NSMutableDictionary alloc]init];
    NSData *dataForUpdate = [value dataUsingEncoding:NSUTF8StringEncoding];
    [dicForUpdate setObject:dataForUpdate forKey:(id)kSecValueData];
    
    BOOL isSucceeded;
    OSStatus status = SecItemUpdate((CFDictionaryRef)dicForSelect, (CFDictionaryRef)dicForUpdate);
    if (status == errSecSuccess) {
        isSucceeded = YES;
    } else {
        isSucceeded = NO;
    }
    [self logAction:@"SecItemUpdate" status:(NSInteger)status];
    
    return isSucceeded;
}

/**
 *  To delete an item from the keychain, we use the `SecItemDelete` function.
 */
+ (BOOL)deleteKeychainItemWithIdentifier:(NSString *)identifier serviceName:(NSString *)serviceName {
    NSMutableDictionary *dicForDelete = [self baseAttributeDictionary:identifier serviceName:serviceName];
    
    BOOL isSucceeded;
    OSStatus status = SecItemDelete((CFDictionaryRef)dicForDelete);
    if (status == errSecSuccess) {
        isSucceeded = YES;
    } else {
        isSucceeded = NO;
    }
    [self logAction:@"SecItemDelete" status:(NSInteger)status];
    
    return isSucceeded;
}

#pragma mark - Private Method
/**
 *  get identifierForVendor String
 */
+ (NSString *)getIDFVString {
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}

/**
 *  This function allocates and constructs a dictionary which defines the attributes of the keychain item you want to insert, delete, update or select.
 */
+ (NSMutableDictionary *)baseAttributeDictionary:(NSString *)identifier serviceName:(NSString *)serviceName {
    NSMutableDictionary *baseAttributeDictionary = [[NSMutableDictionary alloc] init];
    
    /**
     *  key `kSecClass` defines the class of the keychain item we will be dealing with. I want to store a UDID string(more like a password) into the keychain so I use `kSecClassGenericPassword` for the key's value.
     */
    [baseAttributeDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    
    /**
     *  key `kSecAttrGeneric` is what we will use to identify the keychain item. It can be any value we choose such as “Password” or “License”, etc. To be clear this is not the actual value of the keychain item just a label we will attach to this keychain item so we can find it later. In theory our application could store a number of items in the keychain so we need to have a way to identify this particular one from the others. The value for the key `kSecAttrGeneric` has to be encoded before being added to the dictionary.
     */
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [baseAttributeDictionary setObject:encodedIdentifier forKey:(id)kSecAttrGeneric];
    
    /**
     *  key `kSecAttrAccount` and `kSecAttrService` should be set to something unique for this keychain.
     */
    [baseAttributeDictionary setObject:encodedIdentifier forKey:(id)kSecAttrAccount];
    [baseAttributeDictionary setObject:serviceName forKey:(id)kSecAttrService];
    
    return baseAttributeDictionary;
}

+ (void)logAction:(NSString *)action status:(NSInteger)status {
    NSLog(@"%@ Keychain Executed: `[KeychainAction: %@], [OSStatus: %ld]`", NSStringFromClass(self.class), action,(long)status);
}

@end

