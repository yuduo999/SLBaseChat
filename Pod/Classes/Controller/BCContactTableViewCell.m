//
//  ContactListTableViewCell.m
//  OAChat
//
//  Created by song.zhang on 15/4/8.
//  Copyright (c) 2015年 sino-life. All rights reserved.
//

#import "BCContactTableViewCell.h"
#import "BCCommon.h"
#import "ASIHTTPRequest.h"
#import "BaseChatSDK.h"
@implementation BCContactTableViewCell
- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIImageView *contactImage=[[UIImageView alloc]initWithFrame:CGRectMake(14,10, 40,40)];
      
        [self.contentView addSubview:contactImage];
        
        contactImage.layer.masksToBounds = YES;
        contactImage.layer.cornerRadius = 6.0;
        contactImage.layer.borderWidth = 0;
        contactImage.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        self.contactImage=contactImage;
        
       UILabel *contactNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(contactImage.frame)+10,20, kScreenWidth-CGRectGetMaxX(contactImage.frame)-5-20-45, 20)];
        contactNameLabel.backgroundColor=[UIColor clearColor];
        contactNameLabel.textColor=[UIColor blackColor];
        contactNameLabel.font=[UIFont systemFontOfSize:18];
        [self addSubview:contactNameLabel];
        self.contactNameLabel=contactNameLabel;
        
    }
    return self;
}

-(void)downloadOneHeadImage:(NSString *)imageName  withDataUser:(NSString *)dataUser withLoginToken:(NSString *)loginToken{
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
         self.contactImage.image= [BCCommon getUserHeadImageFromImageName:[NSString stringWithFormat:@"%@.jpg",imageName] withUserId:dataUser];
    }];
    [request setFailedBlock:^{
         self.contactImage.image=[UIImage imageNamed:@"SLBaseChat.bundle/user_default_head"];
    }];
    [request startAsynchronous];
    
    
}



-(void)initData:(ContactEntity *)data withDataUser:(NSString *)dataUser withLoginToken:(NSString *)loginToken{
    
    
        if (![data.contactHead isKindOfClass:[NSNull class]] &&data.contactHead.length>0) {
            NSString *filePath = [[BCCommon getUserHeadImageSavePath:dataUser] stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.jpg",data.contactHead]];
            BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
            if (!blHave) {
                [self downloadOneHeadImage:data.contactHead withDataUser:dataUser withLoginToken:loginToken];
            }else{
                self.contactImage.image= [BCCommon getUserHeadImageFromImageName:[NSString stringWithFormat:@"%@.jpg",data.contactHead] withUserId:dataUser];
            }
            
            
        }else{
            self.contactImage.image=[UIImage imageNamed:@"SLBaseChat.bundle/user_default_head"];
        }
    self.contactNameLabel.text=data.nickName;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
