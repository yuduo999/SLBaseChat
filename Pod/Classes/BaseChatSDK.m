//
//  BaseChatSDK.m
//  BaseChatSDK
//
//  Created by song.zhang on 16/3/18.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import "BaseChatSDK.h"

#import "InterfaceOfIMData.h"
#import "BCGlobalMacro.h"
#import "LoginUserDAO.h"
#import "ContactDAO.h"
#import "GroupDAO.h"
#import "GroupMemberDAO.h"
#import "BCCommon.h"
#import "pinyin.h"
@implementation BaseChatSDK

static id __instance;

#pragma mark - instance -

+(instancetype) defaultCore {
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

-(void)getGroupList:(NSString *)loginToken withVersion:(NSNumber *)version withDataUser:(NSString *)dataUser{
    
    NSString *urlString=[NSString stringWithFormat:@"%@/user/groups?groupVersion=%@",self.BCWebServiceURL,[BCCommon ValiNumber:version]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.defaultResponseEncoding=NSUTF8StringEncoding;
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"Authorization" value:loginToken];
    [request setRequestMethod:@"GET"];
    
    [request setCompletionBlock:^{
        if ([request responseStatusCode]/100!=2) {
            return;
        }
        
        NSError *error;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",responseObject);
        NSMutableArray *data= [responseObject objectForKey:@"groups"];
        
//        g_groupVersion=[responseObject objectForKey:@"groupVersion"];
//        [[NSUserDefaults standardUserDefaults] setObject:g_groupVersion forKey:@"groupVersion"];
//        
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
        for (int m=0; m<data.count; m++) {
            NSString *groupId=[[data objectAtIndex:m] objectForKey:@"groupId"];
            NSString *groupHead=[[data objectAtIndex:m] objectForKey:@"portraitUrl"] ;
            NSString *groupCreator=[[data objectAtIndex:m] objectForKey:@"creater"] ;
            NSString *groupName=[BCCommon ValiString:[[data objectAtIndex:m] objectForKey:@"groupName"]];
            NSString *groupRemark=[BCCommon ValiString:[[data objectAtIndex:m] objectForKey:@"description"] defaultValue:@"-"];
            NSNumber *groupVersion=[[data objectAtIndex:m] objectForKey:@"groupVersion"];
            
            BOOL groupValid=[[[data objectAtIndex:m] objectForKey:@"valid"] isEqualToString:@"Y"]?YES:NO;
            
            if (groupValid) {
                [[GroupDAO defaultInstance]tryInsert:groupId withName:groupName withHead:groupHead withRemark:groupRemark withGroupCreator:groupCreator withGroupVersion:groupVersion withDataUser:dataUser];
                
                NSMutableArray *tempMembers= [[data objectAtIndex:m] objectForKey:@"members"];
                
                for (NSDictionary *t in tempMembers) {
                    NSString *memberId=[t objectForKey:@"memberId"];
                    NSString *memberName=[t objectForKey:@"nickname"];
                    NSString *memberHead=[t objectForKey:@"portraitUrl"];
                    [[GroupMemberDAO defaultInstance]tryInsert:memberId withGroupId:groupId withName:memberName withNickName:memberName withHead:memberHead withJoinDate:nil withIsAdmin:NO withIsVaild:YES withDataUser:dataUser];
                    
                }
                
                
            }else{
                [[GroupDAO defaultInstance]remove:groupId withDataUser:dataUser];
                [[GroupMemberDAO defaultInstance]removeAll:groupId withDataUser:dataUser];
            }
            
        }
        if (data.count>0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ON_REFRESH_GROUP object:nil];
        }

        
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}



-(void)getContactList:(NSString *)loginToken withVersion:(NSNumber *)version withDataUser:(NSString *)dataUser{
  
    NSString *urlString=[NSString stringWithFormat:@"%@/user/contacts?contactVersion=%@",self.BCWebServiceURL,[BCCommon ValiNumber:version]];
    NSLog(@"%@",urlString);
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.defaultResponseEncoding=NSUTF8StringEncoding;
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"Authorization" value:loginToken];
    [request setRequestMethod:@"GET"];
    
    [request setCompletionBlock:^{
        if ([request responseStatusCode]/100!=2) {
            return;
        }
        NSError *error;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",responseObject);
        
        NSNumber *contactVersion=[[NSNumber alloc] initWithInteger:[[responseObject objectForKey:@"contactVersion"] integerValue]];
        if ([version integerValue]<[contactVersion integerValue]) {
             [[LoginUserDAO defaultInstance]updateContactVersion:contactVersion withUserId:dataUser];
        }
        NSMutableArray *contactList=[responseObject objectForKey:@"contacts"];
        for (int n=0; n<contactList.count; n++) {
            NSNumber *validStatus=[[contactList objectAtIndex:n] objectForKey:@"relation"];
            
            NSString *contactId=[[contactList objectAtIndex:n] objectForKey:@"contactId"];
            NSString *contactName=[[contactList objectAtIndex:n] objectForKey:@"nickname"];
            NSString *nickName=[[contactList objectAtIndex:n] objectForKey:@"nickname"];
            if ([contactName isKindOfClass:[NSNull class]] || contactName.length == 0){
                contactName=@"无名氏";
            }
            NSString *contactHead=[[contactList objectAtIndex:n] objectForKey:@"portraitUrl"] ;
            
            NSString *pinYinResult=[NSString string];
            for(int j=0;j<contactName.length;j++){
                NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([contactName characterAtIndex:j])]uppercaseString];
                
                pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            
            NSString *contactPinY=pinYinResult;
            
            if ([validStatus isEqualToNumber:@(0)]) {
                [[ContactDAO defaultInstance]tryInsert:contactId withNickName:nickName withHead:contactHead withConatctPinY:contactPinY withDataUser:dataUser];
            }
            else{
                [[ContactDAO defaultInstance]remove:contactId withDataUser:dataUser];
            }
        }
        if (contactList.count>0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ON_REFRESH_CONTACT object:nil];
        }
       
        
    }];
    [request setFailedBlock:^{
    }];
    [request startAsynchronous];
}

-(void)login:(NSString *)userName withPassword:(NSString *)password withDeviceToken:(NSString *)deviceToken withAppKey:(NSString *)appKey{
    
    NSMutableData *jsonData=[InterfaceOfIMData IMgetLogin:userName password:password deviceToken:deviceToken appKey: appKey];
    NSString *urlString=[NSString stringWithFormat:@"%@/user/tokens",self.BCWebServiceURL];
    NSLog(@"%@",urlString);
    NSLog(@"-----提交IM登录信息-----");
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.defaultResponseEncoding=NSUTF8StringEncoding;
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request setRequestMethod:@"POST"];
    [request setPostBody:jsonData];
    
    [request setCompletionBlock:^{
        NSLog(@"----处理登录返回数据---");
        if ([request responseStatusCode]/100!=2) {
            NSString *message=[[ NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
            NSLog(@"%@====",message);
            NSString *errorMessage=[NSString stringWithFormat:@"错误：%d",[request responseStatusCode]];
            NSLog(@"%@",errorMessage);
            
        }
        
        NSError *error;
        
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",responseObject);
        
        NSDictionary *result=[NSDictionary dictionaryWithObjectsAndKeys:@"Y",@"result",[responseObject objectForKey:@"_id"],@"userId",[responseObject objectForKey:@"token"],@"token", nil];
        
        [[LoginUserDAO defaultInstance] tryInsert:[responseObject objectForKey:@"_id"] withName:[responseObject objectForKey:@"userName"] withNickName:[responseObject objectForKey:@"nickname"]  withHead:[responseObject objectForKey:@"portraitUrl"] withToken:[responseObject objectForKey:@"token"] withSessionId:[[NSNumber alloc] initWithInteger:[[responseObject objectForKey:@"sessionId"] integerValue]]];
        
        
        NSString *tempName=[responseObject objectForKey:@"userName"];
        
        NSString *pinYinResult=[NSString string];
        for(int j=0;j<tempName.length;j++){
            NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([tempName characterAtIndex:j])]uppercaseString];
            
            pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
        }
        
        [[ContactDAO defaultInstance] tryInsert:[responseObject objectForKey:@"_id"] withNickName:[responseObject objectForKey:@"nickname"] withHead:[responseObject objectForKey:@"portraitUrl"] withConatctPinY:pinYinResult  withDataUser:[responseObject objectForKey:@"_id"]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ON_IMLOGIN object:result];
    }];
    [request setFailedBlock:^{
        NSString *errorMessage=nil;
        if ([request responseStatusCode]==401) {
            errorMessage=NSLocalizedString(@"error_account", nil);
        }else if([request responseStatusCode]==0) {
            errorMessage=NSLocalizedString(@"error_server_disconnect", nil);
            
        }else{
            errorMessage=[NSString stringWithFormat:@"IM登录失败：%d",[request responseStatusCode]];
        }
        NSLog(@"%@",errorMessage);
        NSDictionary *result=[NSDictionary dictionaryWithObjectsAndKeys:@"N",@"result", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ON_IMLOGIN object:result];
    }];
    [request startAsynchronous];
    
}


-(void)loginOut:(NSString *)loginToken{
    
    NSString *urlString=[NSString stringWithFormat:@"%@/user/tokens",self.BCWebServiceURL];
    NSLog(@"%@",urlString);
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.defaultResponseEncoding=NSUTF8StringEncoding;
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"Authorization" value:loginToken];
    [request setRequestMethod:@"PUT"];
    
    [request setCompletionBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ON_IMLOGINOUT object:@"Y"];
    }];
    [request setFailedBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ON_IMLOGINOUT object:@"N"];
    }];
    [request startAsynchronous];
    
}
@end
