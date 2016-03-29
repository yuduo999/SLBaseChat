//
//  MessageDAO.m
//  BaseChat
//
//  Created by song.zhang on 16/3/16.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import "MessageDAO.h"
#import "MessageEntity.h"
#import "CoreDataHelper.h"
#import "NSManagedObject+BCSDK.h"
@implementation MessageDAO
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

-(MessageEntity *) getMessageById:(NSNumber *)messageId withSessionId:(NSNumber *)sessionId withRecivedId:(NSString *)recivedId withSendorId:(NSString *)sendorId withDataUser:(NSString *)dataUser {
    return [MessageEntity objectWithCondition:[NSString stringWithFormat:@"messageId=='%@' and sessionId=='%@' and recivedId=='%@' and sendorId=='%@' and dataUser=='%@'", messageId,sessionId,recivedId,sendorId,dataUser]];
}



-(void) tryInsert:(NSNumber *) messageId withSessionId:(NSNumber *)sessionId withRecivedId:(NSString *)recivedId withSendorId:(NSString *)sendorId withRcvSeq:(NSNumber *)rcvSeq withMessageType:(NSNumber *)messageType withMessageStatus:(NSNumber *)messageStatus withMessageDate:(NSNumber *)messageDate withMessageContent:(NSString *)messageContent withContentType:(NSNumber *)contentType withAdditionalData:(NSString *)additionalData withDataUser:(NSString *)dataUser{
    MessageEntity * messageData =[self getMessageById:messageId withSessionId:sessionId withRecivedId:recivedId withSendorId:sendorId withDataUser:dataUser];
    if (messageData) {
        messageData.messageId=messageId;
        messageData.messageStatus=messageStatus;
        messageData.messageDate=messageDate;
        messageData.messageContent=messageContent;
        messageData.messageType=messageType;
        messageData.sendorId=sendorId;
        messageData.sessionId =sessionId;
        messageData.recivedId=recivedId;
        messageData.rcvSeq=rcvSeq;
        messageData.contentType=contentType;
        messageData.additionalData=additionalData;
        messageData.dataUser=dataUser;
        [CoreDataHelper saveContext];
        
    }else{
        [self insert:messageId withSessionId:sessionId withRecivedId:recivedId withSendorId:sendorId withRcvSeq:rcvSeq withMessageType:messageType withMessageStatus:messageStatus withMessageDate:messageDate withMessageContent:messageContent withContentType:contentType withAdditionalData:additionalData withDataUser:dataUser];
    }
    
}

-(void) insert:(NSNumber *) messageId withSessionId:(NSNumber *)sessionId withRecivedId:(NSString *)recivedId withSendorId:(NSString *)sendorId withRcvSeq:(NSNumber *)rcvSeq withMessageType:(NSNumber *)messageType withMessageStatus:(NSNumber *)messageStatus withMessageDate:(NSNumber *)messageDate withMessageContent:(NSString *)messageContent withContentType:(NSNumber *)contentType withAdditionalData:(NSString *)additionalData withDataUser:(NSString *)dataUser{
    
    MessageEntity * messageData = [MessageEntity newObject];
    messageData.messageId=messageId;
    messageData.messageStatus=messageStatus;
    messageData.messageDate=messageDate;
    messageData.messageContent=messageContent;
    messageData.messageType=messageType;
    messageData.sendorId=sendorId;
    messageData.sessionId =sessionId;
    messageData.recivedId=recivedId;
    messageData.rcvSeq=rcvSeq;
    messageData.contentType=contentType;
    messageData.additionalData=additionalData;
    messageData.dataUser=dataUser;
    [CoreDataHelper saveContext];
}

-(void) remove:(NSNumber *)messageId withSessionId:(NSNumber *)sessionId withRecivedId:(NSString *)recivedId withSendorId:(NSString *)sendorId withDataUser:(NSString *)dataUser {
    MessageEntity * messageData =[self getMessageById:messageId withSessionId:sessionId withRecivedId:recivedId withSendorId:sendorId withDataUser:dataUser];
    if (messageData) {
        [[CoreDataHelper managedObjectContext] deleteObject:messageData];
        [CoreDataHelper saveContext];
    }
}



-(BOOL) exist:(NSNumber *)messageId withSessionId:(NSNumber *)sessionId withRecivedId:(NSString *)recivedId withSendorId:(NSString *)sendorId withDataUser:(NSString *)dataUser {
    MessageEntity * messageData =[self getMessageById:messageId withSessionId:sessionId withRecivedId:recivedId withSendorId:sendorId withDataUser:dataUser];
    if (messageData) {
        return YES;
    }
    return NO;
}

- (NSMutableArray *) _objectsByPredicate:(NSPredicate *) predicate withPageSize:(NSInteger)pageSize withPageIndex:(NSInteger)pageIndex {
    NSManagedObjectContext *context = [CoreDataHelper managedObjectContext];
    if (context) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MessageEntity" inManagedObjectContext:context];
        [request setEntity:entity];
        request.predicate = predicate;
        request.fetchLimit=pageSize;
        request.fetchOffset=pageIndex*pageSize;
        NSSortDescriptor * sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"rcvSeq" ascending:NO];
        request.sortDescriptors = @[sortDesc];
        NSError *error = nil;
        NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
        
        return mutableFetchResults;
        
    }
    return nil;
}

-(NSMutableArray *) getAllMessage:(NSNumber *) messageType withChatUser:(NSString *)chatUser withPageIndex:(NSInteger)pageIndex withPageSize:(NSInteger)pageSize withDataUser:(NSString *) dataUser {
    NSString *whereSql=[NSString stringWithFormat:@"messageType=='%@' and dataUser=='%@'", messageType, dataUser];
    whereSql=[NSString stringWithFormat:@"%@ or (recivedId=='%@' and sendorId='%@') or (recivedId=='%@' and sendorId='%@') ",whereSql,chatUser,dataUser,dataUser,chatUser];
    
    return [self _objectsByPredicate:[NSPredicate predicateWithFormat:whereSql] withPageSize:pageSize withPageIndex:pageIndex];
}






@end