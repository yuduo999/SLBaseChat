//
//  GroupEntity.h
//  BaseChat
//
//  Created by song.zhang on 16/3/10.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface GroupEntity : NSManagedObject
@property (nonatomic, retain) NSString * groupId;
@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSString * groupRemark;
@property (nonatomic, retain) NSString * groupHead;
@property (nonatomic, retain) NSString * groupCreator;
@property (nonatomic, retain) NSString * dataUser;
@property (nonatomic, retain) NSNumber * groupVersion;

@end
