//
//  InterfaceOfData.h
//  SinoShop
//
//  Created by song.zhang on 14-8-1.
//  Copyright (c) 2014年 song.zhang. All rights reserved.
//
#import <Foundation/Foundation.h>


/**
 功能描述：   后台数据接口定义
 创建人：     张松
 创建日期：   2014-09-11
 
 */
@interface InterfaceOfIMData : NSObject


+(NSMutableData *)IMgetAppError:(NSString *)deviceType withUserId:(NSString *)userId withErrorContent:(NSString *)errorContent;
//  获取登录消息
+(NSMutableData *)IMgetLogin:(NSString *)account password:(NSString *)pwd deviceToken:(NSString *)deviceToken appKey:(NSString *)appKey;

//  创建群
+(NSMutableData *)IMgetCreateGroup:(NSString *)groupName withDescription:(NSString *)description withPortrait:(NSString *)portrait withMembers:(NSString *)members;
+(NSMutableData *)IMgetAddGroupMember:(NSString *)groupMembers;
// 添加联系人
+(NSMutableData *)IMgetAddContact:(NSString *)userId remark:(NSString *)remark;
+(NSMutableData *)IMgetLostMessage:(NSNumber *)maxRcvSeq withLostMessage:(NSMutableArray *)lostMessage;
//  修改特点用户信息
+(NSMutableData *)IMgetModifyUserInfo:(NSString *)userId withUserName:(NSString *)userName withUserHead:(NSString *)userHead;

+(NSMutableData *)IMgetModifyGroupInfo:(NSString *)groupName withDescription:(NSString *)description withGroupHead:(NSString *)groupHead;

@end
