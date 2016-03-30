//
//  MessageBox.m
//  SinoShop
//
//  Created by song.zhang on 14-7-21.
//  Copyright (c) 2014年 song.zhang. All rights reserved.
//

#import "MessageBox.h"

@implementation MessageBox

//消息弹出框
+ (void)showMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

//消息弹出框
+ (void)alert:(NSString *)message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}
+ (void)alert:(NSString *)message delegate:(id)delegate
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}





// 自动隐藏消息弹出框
+ (void) dimissAlert:(UIAlertView *)a
{
    if(a)
    {
        [a dismissWithClickedButtonIndex:[a cancelButtonIndex] animated:YES];
    }
}

//弹出确认消息提示框
+ (void)alert:(NSString *)title message:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(title, nil) message:NSLocalizedString(message, nil) delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

//消息弹出框
+ (void)confirm:(NSString *)message delegate:(id)delegate
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(message, nil) delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:@"重试",nil];
    [alertView show];
}


//网络无连接错误
+ (void)alertWorkErrorFromNotNet
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"网络不稳定，请稍候再试", nil) delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}
@end
