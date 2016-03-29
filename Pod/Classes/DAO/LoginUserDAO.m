//
//  LoginUserDAO.m
//  BaseChat
//
//  Created by song.zhang on 16/3/9.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import "LoginUserDAO.h"

#import "CoreDataHelper.h"
#import "NSManagedObject+BCSDK.h"
@implementation LoginUserDAO
static id __instance = nil;

#pragma mark - instance -

+(instancetype) defaultInstance {
    @synchronized (__instance) {
        if (!__instance) {
            __instance = [[self alloc] init];
        }
        return __instance;
    }
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized (__instance) {
        if (!__instance) {
            __instance = [super allocWithZone:zone];
            return __instance;
        }
        return nil;
    }
}

#pragma mark - operations -

-(LoginUserEntity *) getLoginUser:(NSString *)userId {
    return [LoginUserEntity objectWithCondition:[NSString stringWithFormat:@"userId=='%@'", userId]];
}

-(void) updateContactVersion:(NSNumber *)contactVersion withUserId:(NSString *)userId{
    
    LoginUserEntity * userData = [self getLoginUser:userId];
    if (userData) {
        userData.contactVersion=contactVersion;
        [CoreDataHelper saveContext];
        
    }
}

-(void) tryInsert:(NSString *) userId withName:(NSString *) userName withNickName:(NSString *) nickName withHead:(NSString *)userHead withToken:(NSString *)token
    withSessionId:(NSNumber *)sessionId{
    LoginUserEntity * userData = [self getLoginUser:userId];
    if (userData) {
        userData.userId=userId;
        userData.userName=userName;
        userData.userHead=userHead;
        userData.loginToken=token;
        userData.sessionId=sessionId;
        userData.nickName=nickName;
        [CoreDataHelper saveContext];
        
    }else{
         [self insert:userId withName:userName withNickName:nickName withHead:userHead withToken:token withSessionId:sessionId];
    }

}

-(void) insert:(NSString *) userId withName:(NSString *) userName withNickName:(NSString *) nickName withHead:(NSString *)userHead withToken:(NSString *)token
 withSessionId:(NSNumber *)sessionId{
    LoginUserEntity * userData = [LoginUserEntity newObject];
    userData.userId=userId;
    userData.userName=userName;
    userData.userHead=userHead;
    userData.loginToken=token;
    userData.nickName=nickName;
    userData.sessionId=sessionId;
    [CoreDataHelper saveContext];
}

-(void) remove:(NSString *) userId {
    LoginUserEntity * userData = [self getLoginUser:userId];
    if (userData) {
        [[CoreDataHelper managedObjectContext] deleteObject:userData];
        [CoreDataHelper saveContext];
    }
}


-(BOOL) exist:(NSString *) userId {
    LoginUserEntity * userData = [self getLoginUser:userId];
    NSLog(@"%@,%@",userData.userId,userData.userName);
    if (userData) {
        return YES;
    }
    return NO;
}

@end
