//
//  MessageDAO.h
//  BaseChat
//
//  Created by song.zhang on 16/3/16.
//  Copyright © 2016年 song.zhang. All rights reserved.
//
#import <CoreData/CoreData.h>

@interface MessageDAO : NSObject
+(instancetype) defaultInstance;
-(NSMutableArray *) getAllMessage:(NSNumber *) messageType withChatUser:(NSString *)chatUser withPageIndex:(NSInteger)pageIndex withPageSize:(NSInteger)pageSize withDataUser:(NSString *) dataUser;
-(BOOL) exist:(NSNumber *)messageId withSessionId:(NSNumber *)sessionId withRecivedId:(NSString *)recivedId withSendorId:(NSString *)sendorId withDataUser:(NSString *)dataUser;
-(void) remove:(NSNumber *)messageId withSessionId:(NSNumber *)sessionId withRecivedId:(NSString *)recivedId withSendorId:(NSString *)sendorId withDataUser:(NSString *)dataUser ;

-(void) tryInsert:(NSNumber *) messageId withSessionId:(NSNumber *)sessionId withRecivedId:(NSString *)recivedId withSendorId:(NSString *)sendorId withRcvSeq:(NSNumber *)rcvSeq withMessageType:(NSNumber *)messageType withMessageStatus:(NSNumber *)messageStatus withMessageDate:(NSNumber *)messageDate withMessageContent:(NSString *)messageContent withContentType:(NSNumber *)contentType withAdditionalData:(NSString *)additionalData withDataUser:(NSString *)dataUser;

@end
