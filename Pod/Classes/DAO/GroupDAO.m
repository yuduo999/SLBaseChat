//
//  GroupDAO.m
//  BaseChat
//
//  Created by song.zhang on 16/3/15.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import "GroupDAO.h"
#import "GroupEntity.h"
#import "CoreDataHelper.h"
#import "NSManagedObject+BCSDK.h"
@implementation GroupDAO
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

-(GroupEntity *) getGroupById:(NSString *)groupId withDataUser:(NSString *)dataUser {
    return [GroupEntity objectWithCondition:[NSString stringWithFormat:@"groupId=='%@' and dataUser=='%@'", groupId,dataUser]];
}


-(void) update:(NSString *) groupId withName:(NSString *) groupName withHead:(NSString *)groupHead withRemark:(NSString *)groupRemark
  withGroupCreator:(NSString *)groupCreator withGroupVersion:(NSNumber *)groupVersion
  withDataUser:(NSString *)dataUser{
    
    GroupEntity * groupData= [self getGroupById:groupId withDataUser:dataUser];
    if (groupData) {
        groupData.groupName=groupName;
        groupData.groupHead=groupHead;
        groupData.groupRemark=groupRemark;
        groupData.groupVersion=groupVersion;
        groupData.dataUser=dataUser;
        [CoreDataHelper saveContext];
        
    }else{
        [self insert:groupId withName:groupName withHead:groupHead withRemark:groupRemark withGroupCreator:groupCreator withGroupVersion:groupVersion withDataUser:dataUser];
    }
}

-(void) tryInsert:(NSString *) groupId withName:(NSString *) groupName withHead:(NSString *)groupHead withRemark:(NSString *)groupRemark withGroupCreator:(NSString *)groupCreator withGroupVersion:(NSNumber *)groupVersion withDataUser:(NSString *)dataUser{
    
    GroupEntity * groupData =[self getGroupById:groupId withDataUser:dataUser];
    if (groupData) {
        groupData.groupCreator=groupCreator;
        groupData.groupHead=groupHead;
        groupData.groupId=groupId;
        groupData.groupName=groupName;
        groupData.groupRemark=groupRemark;
        groupData.groupVersion=groupVersion;
        groupData.dataUser=dataUser;
        [CoreDataHelper saveContext];
        
    }else{
        [self insert:groupId withName:groupName withHead:groupHead withRemark:groupRemark withGroupCreator:groupCreator withGroupVersion:groupVersion withDataUser:dataUser];
    }
    
}

-(void) insert:(NSString *) groupId withName:(NSString *) groupName withHead:(NSString *)groupHead withRemark:(NSString *)groupRemark withGroupCreator:(NSString *)groupCreator withGroupVersion:(NSNumber *)groupVersion withDataUser:(NSString *)dataUser{
    GroupEntity * groupData = [GroupEntity newObject];
    groupData.groupVersion=groupVersion;
    groupData.groupRemark=groupRemark;
    groupData.groupName=groupName;
    groupData.groupId=groupId;
    groupData.groupHead=groupHead;
    groupData.groupCreator=groupCreator;
    groupData.dataUser=dataUser;
    [CoreDataHelper saveContext];
}

-(void) remove:(NSString *) groupId withDataUser:(NSString *)dataUser {
    GroupEntity * groupData =[self getGroupById:groupId withDataUser:dataUser];
    if (groupData) {
        [[CoreDataHelper managedObjectContext] deleteObject:groupData];
        [CoreDataHelper saveContext];
    }
}



-(BOOL) exist:(NSString *) groupId withDataUser:(NSString *)dataUser {
    GroupEntity * groupData = [self getGroupById:groupId withDataUser:dataUser];
    NSLog(@"%@,%@",groupData.groupId,groupData.groupName);
    if (groupData) {
        return YES;
    }
    return NO;
}
- (NSMutableArray *) _objectsByPredicate:(NSPredicate *) predicate {
    NSManagedObjectContext *context = [CoreDataHelper managedObjectContext];
    if (context) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"GroupEntity" inManagedObjectContext:context];
        [request setEntity:entity];
        request.predicate = predicate;
        NSSortDescriptor * sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"groupVersion" ascending:NO];
        request.sortDescriptors = @[sortDesc];
        NSError *error = nil;
        NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
        
        return mutableFetchResults;
        
        
        
    }
    return nil;
}

-(NSMutableArray *) getAllGroup:(NSString *) dataUser {
    return [self _objectsByPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"dataUser=='%@'", dataUser]]];
}



@end