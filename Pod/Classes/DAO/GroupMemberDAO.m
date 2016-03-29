//
//  GroupMemberDAO.m
//  BaseChat
//
//  Created by song.zhang on 16/3/15.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import "GroupMemberDAO.h"
#import "GroupMemberEntity.h"
#import "CoreDataHelper.h"
#import "NSManagedObject+BCSDK.h"

@implementation GroupMemberDAO
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

-(GroupMemberEntity *) getGroupMemberById:(NSString *)memberId withGroupId:(NSString *)groupId  withDataUser:(NSString *)dataUser {
    return [GroupMemberEntity objectWithCondition:[NSString stringWithFormat:@"memberId=='%@' and groupId=='%@' and dataUser=='%@'", memberId,groupId,dataUser]];
}



-(void) tryInsert:(NSString *) memberId withGroupId:(NSString *) groupId withName:(NSString *) memberName withNickName:(NSString *) nickName withHead:(NSString *)memberHead withJoinDate:(NSNumber *)joinDate withIsAdmin:(BOOL)isAdmin withIsVaild:(BOOL)isVaild withDataUser:(NSString *)dataUser{
    GroupMemberEntity * groupMemberData =[self getGroupMemberById:memberId withGroupId:groupId withDataUser:dataUser];
    if (groupMemberData) {
        groupMemberData.memberId=memberId;
        groupMemberData.memberName=memberName;
        groupMemberData.memberHead=memberHead;
        groupMemberData.nickName=nickName;
        groupMemberData.groupId=groupId;
        //groupMemberData.joinDate=joinDate;
        groupMemberData.isAdmin =isAdmin;
        //groupMemberData.isVaild=isVaild;
        groupMemberData.dataUser=dataUser;
        [CoreDataHelper saveContext];
        
    }else{
        [self insert: memberId withGroupId: groupId withName: memberName withNickName: nickName withHead:memberHead withJoinDate:joinDate withIsAdmin:isAdmin withIsVaild:isVaild withDataUser:dataUser];
    }
    
}

-(void) insert:(NSString *) memberId withGroupId:(NSString *) groupId withName:(NSString *) memberName withNickName:(NSString *) nickName withHead:(NSString *)memberHead withJoinDate:(NSNumber *)joinDate withIsAdmin:(BOOL)isAdmin withIsVaild:(BOOL)isVaild withDataUser:(NSString *)dataUser{

    GroupMemberEntity * groupMemberData = [GroupMemberEntity newObject];
    groupMemberData.memberId=memberId;
    groupMemberData.memberName=memberName;
    groupMemberData.memberHead=memberHead;
    groupMemberData.nickName=nickName;
    groupMemberData.groupId=groupId;
    //groupMemberData.joinDate=joinDate;
    groupMemberData.isAdmin =isAdmin;
   // groupMemberData.isVaild=isVaild;
    groupMemberData.dataUser=dataUser;
    [CoreDataHelper saveContext];
}

-(void) remove:(NSString *)memberId withGroupId:(NSString *) groupId withDataUser:(NSString *)dataUser {
    GroupMemberEntity * groupMemberData =[self getGroupMemberById:memberId withGroupId:groupId withDataUser:dataUser];
    if (groupMemberData) {
        [[CoreDataHelper managedObjectContext] deleteObject:groupMemberData];
        [CoreDataHelper saveContext];
    }
}

-(void) removeAll:(NSString * )groupId withDataUser:(NSString *)dataUser {
    NSArray * objs = [GroupMemberEntity allObjectsWithCondition:[NSString stringWithFormat:@" groupId=='%@' and dataUser=='%@'",groupId,dataUser]];
    if([objs count] > 0) {
        for(GroupMemberEntity *member in objs) {
            [[CoreDataHelper managedObjectContext] deleteObject:member];
        }
        [CoreDataHelper saveContext];
    }
}


-(BOOL) exist:(NSString *)memberId withGroupId:(NSString *) groupId withDataUser:(NSString *)dataUser {
    GroupMemberEntity * groupMemberData = [self getGroupMemberById:memberId withGroupId:groupId withDataUser:dataUser];
    NSLog(@"%@,%@",groupMemberData.memberId,groupMemberData.groupId);
    if (groupMemberData) {
        return YES;
    }
    return NO;
}

- (NSMutableArray *) _objectsByPredicate:(NSPredicate *) predicate {
    NSManagedObjectContext *context = [CoreDataHelper managedObjectContext];
    if (context) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"GroupMemberEntity" inManagedObjectContext:context];
        [request setEntity:entity];
        request.predicate = predicate;
        NSSortDescriptor * sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"joinDate" ascending:NO];
        request.sortDescriptors = @[sortDesc];
        NSError *error = nil;
        NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
        
        return mutableFetchResults;
        
    }
    return nil;
}

-(NSMutableArray *) getAllGroupMember:(NSString *) groupId withDataUser:(NSString *) dataUser {
    return [self _objectsByPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"dataUser=='%@' and groupId==%@", dataUser, groupId]]];
}






@end