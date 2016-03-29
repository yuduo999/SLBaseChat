//
//  MessageEntity.h
//  BaseChat
//
//  Created by song.zhang on 16/3/10.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface MessageEntity : NSManagedObject
@property (nonatomic, retain) NSNumber * messageId;
@property (nonatomic, retain) NSString * messageContent;
@property (nonatomic, retain) NSString * additionalData;
@property (nonatomic, retain) NSString * dataUser;
@property (nonatomic, retain) NSString * recivedId;
@property (nonatomic, retain) NSString * sendorId;
@property (nonatomic, retain) NSNumber * messageDate;
@property (nonatomic, retain) NSNumber * sessionId;
@property (nonatomic, retain) NSNumber * rcvSeq;
@property (nonatomic, retain) NSNumber * messageStatus;
@property (nonatomic, retain) NSNumber * messageType;
@property (nonatomic, retain) NSNumber * contentType;
@end
