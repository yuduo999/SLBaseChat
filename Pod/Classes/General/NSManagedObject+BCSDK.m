 //
//  NSManagedObject+GoodLawyer.m
//  GoodLawyer
//
//  Created by 曹昊 on 13-6-27.
//
//

#import "NSManagedObject+BCSDK.h"
#import "CoreDataHelper.h"

@implementation NSManagedObject (BCSDK)

+ (NSManagedObjectContext *)context
{
    return [CoreDataHelper managedObjectContext];
}

+ (instancetype)newObject
{
    NSManagedObjectContext *context = [[self class] context];
    if (context) {
        return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    }
    return nil;
}

+ (instancetype)objectWithCondition:(NSString *)condition
{
    NSManagedObjectContext *context = [[self class] context];
    if (context) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
        request.fetchLimit = 1;
        request.predicate = [NSPredicate predicateWithFormat:condition];
        return [[context executeFetchRequest:request error:nil] lastObject];
    }
    return nil;
}

+ (NSArray *)allObjects
{
    NSManagedObjectContext *context = [[self class] context];
    if (context) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
        return [context executeFetchRequest:request error:nil];
    }
    return nil;
}

+ (NSArray *)allObjectsWithCondition:(NSString *)condition
{
    NSManagedObjectContext *context = [[self class] context];
    if (context) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
        request.predicate = [NSPredicate predicateWithFormat:condition];
        return [context executeFetchRequest:request error:nil];
    }
    return nil;
}
@end
