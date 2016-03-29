//
//  SessionDAO.m
//  BaseChat
//
//  Created by song.zhang on 16/3/16.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import "SessionDAO.h"
#import "SessionEntity.h"
#import "CoreDataHelper.h"
#import "NSManagedObject+BCSDK.h"
@implementation SessionDAO
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

-(SessionEntity *) getSessionByChat:(NSString *)sessionChat withDataUser:(NSString *)dataUser {
    return [SessionEntity objectWithCondition:[NSString stringWithFormat:@"sessionChat=='%@' and dataUser=='%@'", sessionChat,dataUser]];
}



-(void) tryInsert:(NSString *)sessionId withSessionICO:(NSString *)sessionICO  withSessionName:(NSString *)sessionName withSessionType:(NSNumber *)sessionType withSessionRemark:(NSString *)sessionRemark withSessionChat:(NSString *)sessionChat withSessionCount:(NSNumber *)sessionCount withSessionDate:(NSNumber *)sessionDate withDataUser:(NSString *)dataUser{
    SessionEntity * sessionData =[self getSessionByChat:sessionChat withDataUser:dataUser];
    if (sessionData) {
        sessionData.sessionId=sessionId;
        sessionData.sessionICO=sessionICO;
        sessionData.sessionName=sessionName;
        sessionData.sessionRemark=sessionRemark;
        sessionData.sessionType=sessionType;
        sessionData.sessionChat=sessionChat;
        sessionData.sessionCount=sessionCount;
        sessionData.sessionDate=sessionDate;
        sessionData.dataUser=dataUser;
        [CoreDataHelper saveContext];
        
    }else{
        [self insert:sessionId withSessionICO:sessionICO  withSessionName:sessionName withSessionType:sessionType withSessionRemark:sessionRemark withSessionChat:sessionChat withSessionCount:sessionCount withSessionDate:sessionDate withDataUser:dataUser];
    }
    
}

-(void) insert:(NSString *)sessionId withSessionICO:(NSString *)sessionICO  withSessionName:(NSString *)sessionName withSessionType:(NSNumber *)sessionType withSessionRemark:(NSString *)sessionRemark withSessionChat:(NSString *)sessionChat withSessionCount:(NSNumber *)sessionCount withSessionDate:(NSNumber *)sessionDate withDataUser:(NSString *)dataUser{
    
    SessionEntity * sessionData = [SessionEntity newObject];
    sessionData.sessionId=sessionId;
    sessionData.sessionICO=sessionICO;
    sessionData.sessionName=sessionName;
    sessionData.sessionRemark=sessionRemark;
    sessionData.sessionType=sessionType;
    sessionData.sessionChat=sessionChat;
    sessionData.sessionCount=sessionCount;
    sessionData.sessionDate=sessionDate;
    sessionData.dataUser=dataUser;
    [CoreDataHelper saveContext];
}

-(void) remove:(NSString *)sessionChat withDataUser:(NSString *)dataUser {
    SessionEntity * sessionData =[self getSessionByChat:sessionChat withDataUser:dataUser];
    if (sessionData) {
        [[CoreDataHelper managedObjectContext] deleteObject:sessionData];
        [CoreDataHelper saveContext];
    }
}



-(BOOL) exist:(NSString *)sessionChat withDataUser:(NSString *)dataUser {
    SessionEntity * sessionData =[self getSessionByChat:sessionChat withDataUser:dataUser];
    if (sessionData) {

        return YES;
    }
    return NO;
}

- (NSMutableArray *) _objectsByPredicate:(NSPredicate *) predicate {
    NSManagedObjectContext *context = [CoreDataHelper managedObjectContext];
    if (context) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"SessionEntity" inManagedObjectContext:context];
        [request setEntity:entity];
        request.predicate = predicate;
        NSSortDescriptor * sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"sessionDate" ascending:YES];
        request.sortDescriptors = @[sortDesc];
        NSError *error = nil;
        NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
        
        return mutableFetchResults;
        
    }
    return nil;
}

-(NSMutableArray *) getSessionData:(NSString *) dataUser {
    NSString *whereSql=[NSString stringWithFormat:@"dataUser=='%@'",dataUser];
    return [self _objectsByPredicate:[NSPredicate predicateWithFormat:whereSql]];
}






@end