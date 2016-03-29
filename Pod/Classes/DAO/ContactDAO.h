//
//  ContactDAO.h
//  BaseChat
//
//  Created by song.zhang on 16/3/10.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ContactEntity.h"
@interface ContactDAO : NSObject
+(instancetype) defaultInstance;

-(void) remove:(NSString *) contactId withDataUser:(NSString *)dataUser;
-(BOOL) exist:(NSString *) contactId withDataUser:(NSString *)dataUser;
-(void) tryInsert:(NSString *) contactId withNickName:(NSString *)nickName withHead:(NSString *)contactHead  withConatctPinY:(NSString *)contactPinY  withDataUser:(NSString *)dataUser;
-(void) update:(NSString *) contactId withName:(NSString *) contactName withHead:(NSString *)contactHead  withConatctPinY:(NSString *)contactPinY  withRemark:(NSString *)contactRemark withNickName:(NSString *)nickName withEmail:(NSString *)email withMobile:(NSString *)mobile withDataUser:(NSString *)dataUser;
-(void) updateHead:(NSString *) contactId withHead:(NSString *)contactHead withDataUser:(NSString *)dataUser;
-(NSMutableArray *) getAllContact:(NSString *) dataUser;
-(ContactEntity *) getContactById:(NSString *)contactId withDataUser:(NSString *)dataUser;
@end
