//
//  ContactDAO.m
//  BaseChat
//
//  Created by song.zhang on 16/3/10.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import "ContactDAO.h"

#import "CoreDataHelper.h"
#import "NSManagedObject+BCSDK.h"
@implementation ContactDAO
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

-(ContactEntity *) getContactById:(NSString *)contactId withDataUser:(NSString *)dataUser {
    return [ContactEntity objectWithCondition:[NSString stringWithFormat:@"contactId=='%@' and dataUser=='%@'", contactId,dataUser]];
}
-(void) updateHead:(NSString *) contactId withHead:(NSString *)contactHead withDataUser:(NSString *)dataUser{
    
    ContactEntity * contactData = [self getContactById:contactId withDataUser:dataUser];
    if (contactData) {
        contactData.contactHead=contactHead;
        [CoreDataHelper saveContext];
        
    }
}
-(void) update:(NSString *) contactId withName:(NSString *) contactName withHead:(NSString *)contactHead  withConatctPinY:(NSString *)contactPinY  withRemark:(NSString *)contactRemark withNickName:(NSString *)nickName withEmail:(NSString *)email withMobile:(NSString *)mobile withDataUser:(NSString *)dataUser{
    
    ContactEntity * contactData = [self getContactById:contactId withDataUser:dataUser];
    if (contactData) {
        contactData.contactRemark=contactRemark;
        contactData.contactName=contactName;
        contactData.contactHead=contactHead;
        contactData.contactPinY=contactPinY;
        contactData.nickName=nickName;
        contactData.mobile=mobile;
        contactData.email=email;
        contactData.dataUser=dataUser;
        [CoreDataHelper saveContext];
        
    }else{
        [self insertAll:contactId withName:contactName withHead:contactHead withConatctPinY:contactPinY withRemark:contactRemark withNickName:nickName withEmail:email withMobile:mobile withDataUser:dataUser];
    }
}

-(void) tryInsert:(NSString *) contactId withNickName:(NSString *)nickName withHead:(NSString *)contactHead  withConatctPinY:(NSString *)contactPinY  withDataUser:(NSString *)dataUser{
    ContactEntity * contactData =[self getContactById:contactId withDataUser:dataUser];
    if (contactData) {
        contactData.contactHead=contactHead;
        contactData.contactPinY=contactPinY;
        contactData.nickName=nickName;
        contactData.dataUser=dataUser;
        [CoreDataHelper saveContext];
        
    }else{
        [self insert:contactId withNickName:nickName withHead:contactHead withConatctPinY:contactPinY withDataUser:dataUser];
    }

}
-(void) insert:(NSString *) contactId withNickName:(NSString *)nickName withHead:(NSString *)contactHead  withConatctPinY:(NSString *)contactPinY withDataUser:(NSString *)dataUser{
    ContactEntity * contactData = [ContactEntity newObject];
    contactData.contactId=contactId;
    contactData.contactHead=contactHead;
    contactData.contactPinY=contactPinY;
    contactData.nickName=nickName;
    contactData.dataUser=dataUser;
    [CoreDataHelper saveContext];
}

-(void) insertAll:(NSString *) contactId withName:(NSString *) contactName withHead:(NSString *)contactHead  withConatctPinY:(NSString *)contactPinY  withRemark:(NSString *)contactRemark withNickName:(NSString *)nickName withEmail:(NSString *)email withMobile:(NSString *)mobile  withDataUser:(NSString *)dataUser{
    ContactEntity * contactData = [ContactEntity newObject];
    contactData.contactRemark=contactRemark;
    contactData.contactId=contactId;
    contactData.contactName=contactName;
    contactData.contactHead=contactHead;
    contactData.contactPinY=contactPinY;
    contactData.nickName=nickName;
    contactData.mobile=mobile;
    contactData.email=email;
    contactData.dataUser=dataUser;
    [CoreDataHelper saveContext];
}

-(void) remove:(NSString *) contactId withDataUser:(NSString *)dataUser {
    ContactEntity * contactData =[self getContactById:contactId withDataUser:dataUser];
    if (contactData) {
        [[CoreDataHelper managedObjectContext] deleteObject:contactData];
        [CoreDataHelper saveContext];
    }
}
-(BOOL) exist:(NSString *) contactId withDataUser:(NSString *)dataUser {
    ContactEntity * contactData = [self getContactById:contactId withDataUser:dataUser];
    NSLog(@"%@,%@",contactData.contactId,contactData.contactName);
    if (contactData) {
        return YES;
    }
    return NO;
}

- (NSMutableArray *) _objectsByPredicate:(NSPredicate *) predicate {
    NSManagedObjectContext *context = [CoreDataHelper managedObjectContext];
    if (context) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ContactEntity" inManagedObjectContext:context];
        [request setEntity:entity];
         request.predicate = predicate;
        NSSortDescriptor * sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"contactPinY" ascending:YES];
        request.sortDescriptors = @[sortDesc];
        NSError *error = nil;
        NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
        
        return mutableFetchResults;
        
       
       
    }
    return nil;
}

-(NSMutableArray *) getAllContact:(NSString *) dataUser {
    return [self _objectsByPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"dataUser=='%@'", dataUser]]];
}

@end