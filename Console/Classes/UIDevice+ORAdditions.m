/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2016, OpenRemote Inc.
 *
 * See the contributors.txt file in the distribution for a
 * full listing of individual contributors.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#import "UIDevice+ORAdditions.h"
#import "GBDeviceInfo.h"

NSString *const DEVICE_TYPE_IPAD_PRO_12 = @"iPadPro12";
NSString *const DEVICE_TYPE_IPAD = @"iPad";
NSString *const DEVICE_TYPE_IPAD3 = @"iPad3";
NSString *const DEVICE_TYPE_IPHONE_6_PLUS = @"iPhone6Plus";
NSString *const DEVICE_TYPE_IPHONE6 = @"iPhone6";
NSString *const DEVICE_TYPE_IPHONE_5 = @"iPhone5";
NSString *const DEVICE_TYPE_IPHONE_4 = @"iPhone4";
NSString *const DEVICE_TYPE_IPHONE = @"iPhone";

@implementation UIDevice (ORAdditions)

/**
 *
 * @return A prefix NSString according to the following rules:
 * "iPhone" -> all 3.5" non retina screens
 * "iPhone4" -> all 3.5" retina screens
 * "iPhone5" -> all 4" screens
 * "iPhone6" -> all 4.7" screens
 * "iPhone6Plus" -> all 5.5" screens
 * "iPad" -> all non retina iPads
 * "iPad3" -> all non 12.9" retina iPads
 * "iPadPro12" -> iPad Pro 12.9"
 * nil otherwise
 */
- (NSString *)autoSelectPrefix {
    NSString *autoSelectPrefix;

    GBDeviceInfo *deviceInfo = [GBDeviceInfo deviceInfo];

    switch (deviceInfo.model) {
        case GBDeviceModeliPadPro12p9Inch:
            autoSelectPrefix = DEVICE_TYPE_IPAD_PRO_12;
            break;
        case GBDeviceModeliPad1:
        case GBDeviceModeliPad2:
        case GBDeviceModeliPadMini1:
            autoSelectPrefix = DEVICE_TYPE_IPAD;
            break;
        case GBDeviceModeliPad3:
        case GBDeviceModeliPad4:
        case GBDeviceModeliPadMini2:
        case GBDeviceModeliPadMini3:
        case GBDeviceModeliPadMini4:
        case GBDeviceModeliPadAir1:
        case GBDeviceModeliPadAir2:
        case GBDeviceModeliPadPro9p7Inch:
            autoSelectPrefix = DEVICE_TYPE_IPAD3;
            break;
        case GBDeviceModeliPhone6Plus:
            break;
        case GBDeviceModeliPhone6sPlus:
        case GBDeviceModeliPhone7Plus:
            autoSelectPrefix = DEVICE_TYPE_IPHONE_6_PLUS;
            break;
        case GBDeviceModeliPhone6:
        case GBDeviceModeliPhone6s:
        case GBDeviceModeliPhone7:
            autoSelectPrefix = DEVICE_TYPE_IPHONE6;
            break;
        case GBDeviceModeliPhone5:
        case GBDeviceModeliPhone5c:
        case GBDeviceModeliPhone5s:
        case GBDeviceModeliPhoneSE:
        case GBDeviceModeliPod5:
        case GBDeviceModeliPod6:
            autoSelectPrefix = DEVICE_TYPE_IPHONE_5;
            break;
        case GBDeviceModeliPod4:
        case GBDeviceModeliPhone4:
        case GBDeviceModeliPhone4S:
            autoSelectPrefix = DEVICE_TYPE_IPHONE_4;
            break;
        case GBDeviceModeliPod1:
        case GBDeviceModeliPod2:
        case GBDeviceModeliPod3:
            autoSelectPrefix = DEVICE_TYPE_IPHONE;
            break;
        default:
            break;
    }

    return autoSelectPrefix;
}

+ (NSArray<NSString *> *)allAutoSelectPrefixes {
    return @[
            DEVICE_TYPE_IPAD_PRO_12,
            DEVICE_TYPE_IPAD,
            DEVICE_TYPE_IPAD3,
            DEVICE_TYPE_IPHONE_6_PLUS,
            DEVICE_TYPE_IPHONE6,
            DEVICE_TYPE_IPHONE_5,
            DEVICE_TYPE_IPHONE_4,
            DEVICE_TYPE_IPHONE,
    ];
}

@end
