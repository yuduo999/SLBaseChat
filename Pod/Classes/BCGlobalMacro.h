//
//  GlobalMacro.h
//  SinoShop
//
//  Created by song.zhang on 14-7-17.
//  Copyright (c) 2014年 SinoLife. All rights reserved.
//
//  功能描述：全局宏
//判断是否为IOS7系统
#define IOS7 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
#define IOS8 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)
#define NAVBAR_BG (@"SLBaseChat.bundle/bg_navigationBar.png")
//判断手机是否为Iphone4
#define IPHONE4 ([[UIScreen mainScreen] bounds].size.height==480)
#define WINDOW_COLOR                            [UIColor colorWithRed:120/255.0f green:120/255.0f blue:120/255.0f alpha:0.3]
#define ACTIONSHEET_BACKGROUNDCOLOR             [UIColor colorWithRed:132/255.00f green:132/255.00f blue:106/255.00f alpha:0.8]
#define ANIMATE_DURATION                        0.15f


#define NOTIFICATION_ON_IMLOGIN  @"BCSDK_IMLOGIN_SHOWRESULT"
#define NOTIFICATION_ON_IMLOGINOUT  @"BCSDK_IMLOGINOUT_SHOWRESULT"

//刷新联系人列表
#define NOTIFICATION_ON_REFRESH_CONTACT  @"BCSDK_IMREFRESH_CONTACT"

//刷新群组列表
#define NOTIFICATION_ON_REFRESH_GROUP  @"BCSDK_IMREFRESH_GROUP"