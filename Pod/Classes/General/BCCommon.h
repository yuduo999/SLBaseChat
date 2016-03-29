//
//  Common.h
//  OAChat
//
//  Created by song.zhang on 15/5/28.
//  Copyright (c) 2015年 sino-life. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface BCCommon : NSObject
+(NSString *)getUserHeadImageSavePath:(NSString *)userId;
+(UIImage *)getUserHeadImageFromImageName:(NSString *)imageName withUserId:(NSString *)userId;
+(void)SaveLogData:(NSString *)logData withlogName:(NSString *)fileName ;
+(NSString *)readLogData:(NSString *)fileName;

+(NSString *)ValiString:(NSString *)tempString;
+(NSString *)ValiString:(id)tempString  defaultValue:(NSString *)defaultValue;

+(NSInteger)ValiInt:(NSString *)tempString;
+(NSInteger)ValiInt:(id)tempString  defaultValue:(NSInteger)defaultValue;
+(id)ValiNumber:(id)tempString ;
+(id)ValiNumber:(id)tempString  defaultValue:(id)defaultValue;
+(UIImage*)convertViewToImage:(UIView*)view;
@end
