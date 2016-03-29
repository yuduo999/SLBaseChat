//
//  GroupMemberEntity.h
//  BaseChat
//
//  Created by song.zhang on 16/3/10.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface GroupMemberEntity : NSManagedObject
@property (nonatomic, retain) NSString * memberId;
@property (nonatomic, retain) NSString * memberName;
@property (nonatomic, retain) NSString * memberHead;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * groupId;
@property (nonatomic, retain) NSString * dataUser;
@property (nonatomic) BOOL isAdmin;
@property (nonatomic) BOOL  isVaild;
@property (nonatomic, retain) NSNumber * joinDate;
@end
