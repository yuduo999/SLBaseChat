//
//  GroupMemberDAO.h
//  BaseChat
//
//  Created by song.zhang on 16/3/15.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface GroupMemberDAO : NSObject
+(instancetype) defaultInstance;
-(BOOL) exist:(NSString *)memberId withGroupId:(NSString *) groupId withDataUser:(NSString *)dataUser;
-(void) remove:(NSString *)memberId withGroupId:(NSString *) groupId withDataUser:(NSString *)dataUser;
-(void) removeAll:(NSString * )groupId withDataUser:(NSString *)dataUser;
-(void) tryInsert:(NSString *) memberId withGroupId:(NSString *) groupId withName:(NSString *) memberName withNickName:(NSString *) nickName withHead:(NSString *)memberHead withJoinDate:(NSNumber *)joinDate withIsAdmin:(BOOL)isAdmin withIsVaild:(BOOL)isVaild withDataUser:(NSString *)dataUser;

-(NSMutableArray *) getAllGroupMember:(NSString *) groupId withDataUser:(NSString *) dataUser;


@end
