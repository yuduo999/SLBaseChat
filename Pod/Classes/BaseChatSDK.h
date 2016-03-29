//
//  BaseChatSDK.h
//  BaseChatSDK
//
//  Created by song.zhang on 16/3/18.
//  Copyright © 2016年 song.zhang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BCGlobalMacro.h"
#import "BCScreenAdapter.h"
#import "BCMessageMainViewController.h"
#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
@interface BaseChatSDK : NSObject
+(instancetype) defaultCore;
@property (nonatomic, copy) NSString * BCWebServiceURL;
-(void)login:(NSString *)userName withPassword:(NSString *)password withDeviceToken:(NSString *)deviceToken withAppKey:(NSString *)appKey;
-(void)loginOut:(NSString *)loginToken;


-(void)getContactList:(NSString *)loginToken withVersion:(NSNumber *)version withDataUser:(NSString *)dataUser;
-(void)getGroupList:(NSString *)loginToken withVersion:(NSNumber *)version withDataUser:(NSString *)dataUser;
@end