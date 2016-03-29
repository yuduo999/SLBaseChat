//
//  BasicDAO.h
//  YiIMSDK
//
//  Created by saint on 14-5-29.
//  Copyright (c) 2014年 ikantech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CoreDataHelper : NSObject

+ (NSManagedObjectContext *)managedObjectContext;
+ (NSManagedObjectModel *)managedObjectModel;
+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
+ (NSURL *)applicationDocumentsDirectory;
+ (void)saveContext;

@end
