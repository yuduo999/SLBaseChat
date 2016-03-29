//
//  SessionEntity.h
//  BaseChat
//
//  Created by song.zhang on 16/3/10.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface SessionEntity : NSManagedObject
@property (nonatomic, retain) NSString * sessionId;
@property (nonatomic, retain) NSString * sessionName;
@property (nonatomic, retain) NSString * sessionRemark;
@property (nonatomic, retain) NSString * dataUser;
@property (nonatomic, retain) NSString * sessionChat;
@property (nonatomic, retain) NSString * sessionICO;
@property (nonatomic, retain) NSNumber * sessionCount;
@property (nonatomic, retain) NSNumber * sessionType;
@property (nonatomic, retain) NSNumber * sessionDate;
@end
