//
//  MessageBox.h
//  SinoShop
//
//  Created by song.zhang on 14-7-21.
//  Copyright (c) 2014年 song.zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 功能描述：   消息提示框
 创建人：     张松
 创建日期：   2014-09-11
 
 */
@interface MessageBox : NSObject

//消息弹出框
+ (void)alert:(NSString *)message;
+ (void)alert:(NSString *)message delegate:(id)delegate;
//消息弹出框
+ (void)showMessage:(NSString *)message;
// 弹出消息提示框，含标题
+ (void)alert:(NSString *)title message:(NSString *)message;

// 弹出消息提示框，含委托事件
+ (void)confirm:(NSString *)message delegate:(id)delegate;


// 网络无连接错误
+ (void)alertWorkErrorFromNotNet;
@end
