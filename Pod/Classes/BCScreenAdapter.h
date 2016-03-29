//
//  ScreenAdapter.h
//  SinoShop
//
//  Created by song.zhang on 14-7-17.
//  Copyright (c) 2014年 SinoLife. All rights reserved.
//
//  功能描述：配适宏

#define kScreenWidth             ([[UIScreen mainScreen] bounds].size.width)
#define kScreenHeight            ([[UIScreen mainScreen] bounds].size.height)
#define kFullViewWidth           kScreenWidth
#define kFullViewHeight          (kScreenHeight - 113)
#define KNavigationBarHeight    ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0?0:20)
//无底部标签高度
#define kContentHeight          (kScreenHeight - 64)
//#define kKeyBoardHeight ([[UIScreen mainScreen] bounds].size.height==480?216:270)