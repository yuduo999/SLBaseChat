//
//  MessageRcvSeqEntity.h
//  BaseChat
//
//  Created by song.zhang on 16/3/10.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import <CoreData/CoreData.h>
@interface MessageRcvSeqEntity : NSManagedObject
@property (nonatomic, retain) NSString * dataUser;
@property (nonatomic, retain) NSNumber * rcvSeq;
@end
