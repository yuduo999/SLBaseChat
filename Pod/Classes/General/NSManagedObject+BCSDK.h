//
//  NSManagedObject+GoodLawyer.h
//  GoodLawyer
//
//  Created by 曹昊 on 13-6-27.
//
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (BCSDK)

+ (instancetype)newObject;
+ (instancetype)objectWithCondition:(NSString *)condition;
+ (NSArray *)allObjects;
+ (NSArray *)allObjectsWithCondition:(NSString *)condition;

@end
