//
//  MessageRcvSeqDAO.m
//  BaseChat
//
//  Created by song.zhang on 16/3/16.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import "MessageRcvSeqDAO.h"
#import "MessageRcvSeqEntity.h"
#import "CoreDataHelper.h"
#import "NSManagedObject+BCSDK.h"
@implementation MessageRcvSeqDAO
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

-(MessageRcvSeqEntity *) getRcvSeqById:(NSNumber *)rcvSeq withDataUser:(NSString *)dataUser {
    return [MessageRcvSeqEntity objectWithCondition:[NSString stringWithFormat:@"rcvSeq=='%@' and dataUser=='%@'", rcvSeq,dataUser]];
}



-(void) tryInsert:(NSNumber *) rcvSeq withDataUser:(NSString *)dataUser{
    MessageRcvSeqEntity * rcvSeqData =[self getRcvSeqById:rcvSeq withDataUser:dataUser];
    if (rcvSeqData) {
        rcvSeqData.rcvSeq=rcvSeq;
        rcvSeqData.dataUser=dataUser;
        [CoreDataHelper saveContext];
        
    }else{
        [self insert:rcvSeq  withDataUser:dataUser];
    }
    
}

-(void) insert:(NSNumber *) rcvSeq withDataUser:(NSString *)dataUser{
    
    MessageRcvSeqEntity * rcvSeqData = [MessageRcvSeqEntity newObject];
    rcvSeqData.rcvSeq=rcvSeq;
    rcvSeqData.dataUser=dataUser;
    [CoreDataHelper saveContext];
}

-(void) remove:(NSNumber *)rcvSeq withDataUser:(NSString *)dataUser {
    MessageRcvSeqEntity * rcvSeqData =[self getRcvSeqById:rcvSeq withDataUser:dataUser];
    if (rcvSeqData) {
        [[CoreDataHelper managedObjectContext] deleteObject:rcvSeqData];
        [CoreDataHelper saveContext];
    }
}



-(BOOL) exist:(NSNumber *)rcvSeq withDataUser:(NSString *)dataUser {
    MessageRcvSeqEntity * rcvSeqData =[self getRcvSeqById:rcvSeq withDataUser:dataUser];
    if (rcvSeqData) {
        return YES;
    }
    return NO;
}

- (NSMutableArray *) _objectsByPredicate:(NSPredicate *) predicate withPageSize:(NSInteger)pageSize withPageIndex:(NSInteger)pageIndex {
    NSManagedObjectContext *context = [CoreDataHelper managedObjectContext];
    if (context) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MessageRcvSeqEntity" inManagedObjectContext:context];
        [request setEntity:entity];
        request.predicate = predicate;
        request.fetchLimit=pageSize;
        request.fetchOffset=pageIndex*pageSize;
        NSSortDescriptor * sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"rcvSeq" ascending:YES];
        request.sortDescriptors = @[sortDesc];
        NSError *error = nil;
        NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
        
        return mutableFetchResults;
        
    }
    return nil;
}

-(NSMutableArray *) getRcvSeqData:(NSString *) dataUser withPageIndex:(NSInteger)pageIndex withPageSize:(NSInteger)pageSize {
    NSString *whereSql=[NSString stringWithFormat:@"dataUser=='%@'",dataUser];
    return [self _objectsByPredicate:[NSPredicate predicateWithFormat:whereSql] withPageSize:pageSize withPageIndex:pageIndex];
}






@end