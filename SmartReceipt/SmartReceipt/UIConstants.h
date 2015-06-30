//
//  UIConstants.h
//  SmartReceipt
//
//  Created by Michael Rommel on 29.06.15.
//  Copyright (c) 2015 Michael Rommel. All rights reserved.
//

#ifndef SmartReceipt_UIConstants_h
#define SmartReceipt_UIConstants_h

#define PRINT_RECT(text, frame)     NSLog(@"%@: %d,%d -> %dx%d", text, (int)frame.origin.x, (int)frame.origin.y, (int)frame.size.width, (int)frame.size.height)

#define STATUSBAR_HEIGHT            ([UIApplication sharedApplication].statusBarFrame.size.height)

#define BU1                         12
#define BU2                         24
#define BU3                         36
#define BU4                         48
#define BU5                         60

#define DEVICE_WIDTH                ([[UIScreen mainScreen] bounds].size.width)
#define DEVICE_HEIGHT               ([[UIScreen mainScreen] bounds].size.height)

#endif
