//
//  ContactEntity.h
//  BaseChat
//
//  Created by song.zhang on 16/3/10.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ContactEntity : NSManagedObject
@property (nonatomic, retain) NSString * contactId;
@property (nonatomic, retain) NSString * contactName;
@property (nonatomic, retain) NSString * contactPinY;
@property (nonatomic, retain) NSString * contactRemark;
@property (nonatomic, retain) NSString * contactHead;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * dataUser;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * email;
@end
