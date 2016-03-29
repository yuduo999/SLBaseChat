//
//  LoginUserEntity.h
//  BaseChat
//
//  Created by song.zhang on 16/3/9.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface LoginUserEntity : NSManagedObject
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userHead;
@property (nonatomic, retain) NSString * loginToken;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSNumber * sessionId;
@property (nonatomic, retain) NSNumber * contactVersion;
@end
