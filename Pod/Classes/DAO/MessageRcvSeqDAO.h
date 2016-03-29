//
//  MessageRcvSeqDAO.h
//  BaseChat
//
//  Created by song.zhang on 16/3/16.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface MessageRcvSeqDAO : NSObject
+(instancetype) defaultInstance;

-(NSMutableArray *) getRcvSeqData:(NSString *) dataUser withPageIndex:(NSInteger)pageIndex withPageSize:(NSInteger)pageSize;
-(BOOL) exist:(NSNumber *)rcvSeq withDataUser:(NSString *)dataUser;
-(void) remove:(NSNumber *)rcvSeq withDataUser:(NSString *)dataUser;
-(void) tryInsert:(NSNumber *) rcvSeq withDataUser:(NSString *)dataUser;

@end
