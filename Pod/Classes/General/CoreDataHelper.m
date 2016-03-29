//
//  BasicDAO.m
//  YiIMSDK
//
//  Created by saint on 14-5-29.
//  Copyright (c) 2014年 ikantech. All rights reserved.
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper

static NSManagedObjectContext * __managedObjectContext = nil;
static NSManagedObjectModel * __managedObjectModel = nil;
static NSPersistentStoreCoordinator * __persistentStoreCoordinator = nil;

#pragma mark - Core Data -

+ (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

+ (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    __managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:@[[NSBundle mainBundle]]];
    return __managedObjectModel;
}

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BCData.sqlite"];
    
    NSError *error = nil;
    
    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        if (error) {
            NSLog(@"persistentStoreCoordinator error %@",error.localizedDescription);
        }
    }
    
    return __persistentStoreCoordinator;
}

+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+(void)saveContext {
    NSLog(@"save Context");
    NSArray *syms = [NSThread  callStackSymbols];
    if ([syms count] > 1) {
        NSLog(@"<%@ %p> %@ - caller: %@ ", [self class], self, NSStringFromSelector(_cmd),[syms objectAtIndex:1]);
    } else {
        NSLog(@"<%@ %p> %@", [self class], self, NSStringFromSelector(_cmd));
    }
    
    NSError * error = nil;
    if(__managedObjectContext && [__managedObjectContext hasChanges]) {
        if(![__managedObjectContext save:&error]) {
            NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
            NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
            if(detailedErrors != nil && [detailedErrors count] > 0) {
                for(NSError* detailedError in detailedErrors) {
                    NSLog(@"  DetailedError: %@", [detailedError userInfo]);
                }
            }
            else {
                NSLog(@"  %@", [error userInfo]);
            }
        }
    }
    NSLog(@"save Context ok");
}

@end
