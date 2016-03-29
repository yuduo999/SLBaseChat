//
//  GroupDAO.h
//  BaseChat
//
//  Created by song.zhang on 16/3/15.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface GroupDAO : NSObject
+(instancetype) defaultInstance;

-(void) update:(NSString *) groupId withName:(NSString *) groupName withHead:(NSString *)groupHead withRemark:(NSString *)groupRemark
withGroupCreator:(NSString *)groupCreator withGroupVersion:(NSNumber *)groupVersion
  withDataUser:(NSString *)dataUser;
-(void) tryInsert:(NSString *) groupId withName:(NSString *) groupName withHead:(NSString *)groupHead withRemark:(NSString *)groupRemark withGroupCreator:(NSString *)groupCreator withGroupVersion:(NSNumber *)groupVersion withDataUser:(NSString *)dataUser;

-(void) remove:(NSString *) groupId withDataUser:(NSString *)dataUser;
-(BOOL) exist:(NSString *) groupId withDataUser:(NSString *)dataUser;
-(NSMutableArray *) getAllGroup:(NSString *) dataUser;
@end
