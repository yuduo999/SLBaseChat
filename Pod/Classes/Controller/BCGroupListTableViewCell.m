//
//  GroupListTableViewCell.m
//  OAChat
//
//  Created by song.zhang on 15/5/26.
//  Copyright (c) 2015年 sino-life. All rights reserved.
//

#import "BCGroupListTableViewCell.h"
#import "ASIHTTPRequest.h"
#import "BCCommon.h"
#import "GroupDAO.h"
#import "GroupMemberDAO.h"
#import "GroupMemberEntity.h"
#import "BaseChatSDK.h"
@implementation BCGroupListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIImageView *groupHeadImage=[[UIImageView alloc]initWithFrame:CGRectMake(14,10, 50,50)];
        
        [self.contentView addSubview:groupHeadImage];
        groupHeadImage.layer.masksToBounds = YES;
        groupHeadImage.layer.cornerRadius = 6.0;
        groupHeadImage.layer.borderWidth = 0;
        groupHeadImage.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.groupHeadImage=groupHeadImage;
        UILabel *groupNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(groupHeadImage.frame)+10,25, self.bounds.size.width-CGRectGetMaxX(groupHeadImage.frame)-5-20, 20)];
        
        groupNameLabel.backgroundColor=[UIColor clearColor];
        groupNameLabel.textColor=[UIColor blackColor];
        groupNameLabel.font=[UIFont systemFontOfSize:18];
        [self.contentView addSubview:groupNameLabel];
        self.groupNameLabel=groupNameLabel;
    }
    return self;

}
-(void)initData:(GroupEntity *)data  withLoginToken:(NSString *)loginToken{
    headArray=[NSMutableArray array];
    self.groupHeadImage.image=[self getGroupHead:data.groupId  withDataUser:data.dataUser withLoginToken:loginToken];
    
    self.groupNameLabel.text=data.groupName;
    
}
-(void)downloadOneHeadImage:(NSString *)imageName withDataUser:(NSString *)dataUser withLoginToken:(NSString *)loginToken{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *savePath=[BCCommon getUserHeadImageSavePath:dataUser];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:savePath]) {
        [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/portraits/%@",[BaseChatSDK defaultCore].BCWebServiceURL,imageName]];
    
    __block  ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
    
    [request setDownloadDestinationPath:[savePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",imageName]]];
    
    [request setShouldContinueWhenAppEntersBackground:YES];
    request.defaultResponseEncoding=NSUTF8StringEncoding;
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request setRequestMethod:@"GET"];
    [request addRequestHeader:@"Authorization" value:loginToken];
    
    [request setTimeOutSeconds:120];
    
    [request setNumberOfTimesToRetryOnTimeout:3];
    
    [request setCompletionBlock:^{
         [headArray addObject:[BCCommon getUserHeadImageFromImageName:[NSString stringWithFormat:@"%@.jpg",imageName] withUserId:dataUser]];
    }];
    [request setFailedBlock:^{
         [headArray addObject:[BCCommon getUserHeadImageFromImageName:[NSString stringWithFormat:@"%@.jpg",imageName] withUserId:dataUser]];
    }];
    [request startAsynchronous];
    
    
}



-(UIImage *)getGroupHead:(NSString *)groupId withDataUser:(NSString *)dataUser withLoginToken:(NSString *)loginToken{
    UIImage *groupHeadImage=[UIImage imageNamed:@"SLBaseChat.bundle/default_team_icon"];
    
    
    NSMutableArray *data=[[GroupMemberDAO defaultInstance]getAllGroupMember:groupId withDataUser:dataUser];
    if (![data isKindOfClass:[NSNull class]]&&data.count>0){
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            UIView *headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 220)];
            headView.backgroundColor=[UIColor colorWithRed:240.00/255 green:240.00/255 blue:240.00/255 alpha:1.0];
            int left=10;
            int top=10;
            for(int n=0;n<headArray.count&n<9;n++){
                UIImageView *hView=[[UIImageView alloc]initWithFrame:CGRectMake(left,top, 60,60)];
                [hView setImage:[headArray objectAtIndex:n]];
                [hView.layer setMasksToBounds:YES];
                [hView.layer setCornerRadius:10.0];//设置矩形四个圆角半径
                [headView addSubview:hView];
                left+=70;
                if ((n+1)%3==0&&n>0) {
                    left=10;
                    top+=70;
                }
            }
            UIImage * groupHead=[BCCommon convertViewToImage:headView];
            self.groupHeadImage.image=groupHead;
        });
        
        
        UIView *headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 220)];
        headView.backgroundColor=[UIColor colorWithRed:240.00/255 green:240.00/255 blue:240.00/255 alpha:1.0];
        int left=10;
        int top=10;
        
        for(int n=0;n<data.count&n<9;n++){
            GroupMemberEntity *member=[data objectAtIndex:n];
            
            UIImage *userHeadImage=[UIImage imageNamed:@"SLBaseChat.bundle/user_default_head"];
            NSString *headString=member.memberHead;
            if (headString.length>0) {
                NSString *filePath = [[BCCommon getUserHeadImageSavePath:dataUser] stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.jpg",headString]];
                BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
                if (!blHave) {
                    
                    dispatch_group_async(group, queue, ^{
                        [self downloadOneHeadImage:headString withDataUser:dataUser withLoginToken:loginToken];
                    });
                    
                    
                }else{
                    userHeadImage= [BCCommon getUserHeadImageFromImageName:[NSString stringWithFormat:@"%@.jpg",headString] withUserId:dataUser];
                    [headArray addObject:userHeadImage];
                }
            }else{
                [headArray addObject:[UIImage imageNamed:@"SLBaseChat.bundle/user_default_head"]];
            }
            
            UIImageView *hView=[[UIImageView alloc]initWithFrame:CGRectMake(left,top, 60,60)];
            [hView setImage:userHeadImage];
            [hView.layer setMasksToBounds:YES];
            [hView.layer setCornerRadius:10.0];//设置矩形四个圆角半径
            [headView addSubview:hView];
            left+=70;
            if ((n+1)%3==0&&n>0) {
                left=10;
                top+=70;
            }
        }
       groupHeadImage=[BCCommon convertViewToImage:headView];
    }
    return groupHeadImage;
    
}

@end
