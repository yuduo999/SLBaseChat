//
//  SessionDAO.h
//  BaseChat
//
//  Created by song.zhang on 16/3/16.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface SessionDAO : NSObject
+(instancetype) defaultInstance;
-(NSMutableArray *) getSessionData:(NSString *) dataUser;
-(BOOL) exist:(NSString *)sessionChat withDataUser:(NSString *)dataUser;
-(void) remove:(NSString *)sessionChat withDataUser:(NSString *)dataUser;
-(void) tryInsert:(NSString *)sessionId withSessionICO:(NSString *)sessionICO  withSessionName:(NSString *)sessionName withSessionType:(NSNumber *)sessionType withSessionRemark:(NSString *)sessionRemark withSessionChat:(NSString *)sessionChat withSessionCount:(NSNumber *)sessionCount withSessionDate:(NSNumber *)sessionDate withDataUser:(NSString *)dataUser;
@end
