//
//  LoginUserDAO.h
//  BaseChat
//
//  Created by song.zhang on 16/3/9.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "LoginUserEntity.h"
@interface LoginUserDAO : NSObject

+(instancetype) defaultInstance;

-(void) remove:(NSString *) userId;
-(BOOL) exist:(NSString *) userId;
-(void) tryInsert:(NSString *) userId withName:(NSString *) userName withNickName:(NSString *) nickName withHead:(NSString *)userHead withToken:(NSString *)token
    withSessionId:(NSNumber *)sessionId;
-(LoginUserEntity *) getLoginUser:(NSString *)userId;
-(void) updateContactVersion:(NSNumber *)contactVersion withUserId:(NSString *)userId;
@end
