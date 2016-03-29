//
//  InterfaceOfData.m
//  SinoShop
//
//  Created by song.zhang on 14-8-1.
//  Copyright (c) 2014年 song.zhang. All rights reserved.
//
//  功能描述：后台数据接口定义

#import "InterfaceOfIMData.h"

@implementation InterfaceOfIMData



//IM

+(NSMutableData *)IMgetLogin:(NSString *)account password:(NSString *)pwd deviceToken:(NSString *)deviceToken appKey:(NSString *)appKey{
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:account forKey:@"account"];
    [params setObject:pwd forKey:@"password"];
    [params setObject:deviceToken forKey:@"deviceToken"];
    [params setObject:appKey forKey:@"appKey"];
    [params setObject:@"IOS" forKey:@"deviceType"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error: &error];
    
    if (!error) {
        return [NSMutableData dataWithData:jsonData];
    }
    return nil;
    
}
+(NSMutableData *)IMgetAddGroupMember:(NSString *)groupMembers{
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:groupMembers forKey:@"members"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error: &error];
    
    if (!error) {
        return [NSMutableData dataWithData:jsonData];
    }
    return nil;
    
}
+(NSMutableData *)IMgetAppError:(NSString *)deviceType withUserId:(NSString *)userId withErrorContent:(NSString *)errorContent{
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:deviceType forKey:@"deviceType"];
    [params setObject:userId forKey:@"deviceNo"];
    [params setObject:errorContent forKey:@"errorLog"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error: &error];
    
    if (!error) {
        return [NSMutableData dataWithData:jsonData];
    }
    return nil;
}

+(NSMutableData *)IMgetLostMessage:(NSNumber *)maxRcvSeq withLostMessage:(NSMutableArray *)lostMessage{
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:maxRcvSeq forKey:@"rcvSeq"];
    [params setObject:@"20" forKey:@"reqCount"];
    [params setObject:lostMessage forKey:@"seqArr"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error: &error];
    
    if (!error) {
        return [NSMutableData dataWithData:jsonData];
    }
    return nil;
}

+(NSMutableData *)IMgetCreateGroup:(NSString *)groupName withDescription:(NSString *)description withPortrait:(NSString *)portrait withMembers:(NSString *)members{
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:groupName forKey:@"groupName"];
    [params setObject:portrait forKey:@"description"];
    [params setObject:portrait forKey:@"portrait"];
    [params setObject:members forKey:@"members"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error: &error];
    
    if (!error) {
        return [NSMutableData dataWithData:jsonData];
    }
    return nil;
}
+(NSMutableData *)IMgetAddContact:(NSString *)userId remark:(NSString *)remark{
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:userId forKey:@"userId"];
    [params setObject:remark forKey:@"remark"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error: &error];
    
    if (!error) {
        return [NSMutableData dataWithData:jsonData];
    }
    return nil;
    
    
}
+(NSMutableData *)IMgetModifyGroupInfo:(NSString *)groupName withDescription:(NSString *)description withGroupHead:(NSString *)groupHead{
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:groupName forKey:@"groupName"];
    [params setObject:description forKey:@"description"];
    [params setObject:groupHead forKey:@"portrait"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error: &error];
    
    if (!error) {
        return [NSMutableData dataWithData:jsonData];
    }
    return nil;
}
+(NSMutableData *)IMgetModifyUserInfo:(NSString *)userId withUserName:(NSString *)userName withUserHead:(NSString *)userHead{
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:userId forKey:@"userId"];
    [params setObject:userName forKey:@"nickname"];
    [params setObject:userHead forKey:@"file"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error: &error];
    
    if (!error) {
        return [NSMutableData dataWithData:jsonData];
    }
    return nil;
}




@end
