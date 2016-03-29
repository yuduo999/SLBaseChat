//
//  BCPersonInfoViewController.m
//  BaseChatSDK
//
//  Created by song.zhang on 16/3/23.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import "BCPersonInfoViewController.h"
#import "BaseChatSDK.h"
#import "BCCommon.h"
#import "ContactDAO.h"
#import "LoginUserDAO.h"
#import "pinyin.h"
@interface BCPersonInfoViewController ()

@end

@implementation BCPersonInfoViewController
-(id)initWithData:(NSString *)userId withLoginUser:(LoginUserEntity *)loginData {
    self.loginData=loginData;
    NSLog(@"===%@",self.loginData.loginToken);
    self.contactData=[[ContactDAO defaultInstance]getContactById:userId withDataUser:loginData.userId];
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed=YES;
    if (IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"SLBaseChat.bundle/bg_contact_tophead"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,[UIFont fontWithName:@"Helvetica" size:18],UITextAttributeFont,nil] ];
    self.title=@"个人资料";
    UIButton *backBtn =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"SLBaseChat.bundle/nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    

    mainView=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:mainView];
    
    
    headButton=[[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-79.5)/2-1, 11.5, 80, 80)];
    headButton.backgroundColor=[UIColor clearColor];
    headButton.layer.masksToBounds = YES;
    
    headButton.layer.cornerRadius =10.0;
    headButton.layer.borderWidth = 0;
    headButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    if ([self.contactData.contactHead isKindOfClass:[NSNull class]] || self.contactData.contactHead.length == 0){
        [headButton setImage:[UIImage imageNamed:@"SLBaseChat.bundle/user_default_head.png"] forState:UIControlStateNormal];
        
    }else{
        
        NSString *filePath = [[BCCommon getUserHeadImageSavePath:self.loginData.userId] stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.jpg",self.contactData.contactHead]];
        BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
        if (!blHave) {
            [self downloadHeadImage:self.contactData.contactHead];
        }else{
            [headButton setImage:[BCCommon getUserHeadImageFromImageName:[NSString stringWithFormat:@"%@.jpg",self.contactData.contactHead ] withUserId:self.loginData.userId] forState:UIControlStateNormal];
        }
    }

    [mainView addSubview:headButton];
    
    UIView *userNameView=[[UIView alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(headButton.frame)+25, kScreenWidth-40, 50)];
    UIImageView *disViewBg1=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,userNameView.frame.size.width, 50)];
    disViewBg1.image=[UIImage imageNamed:@"SLBaseChat.bundle/bg_cell.png"];
    [userNameView addSubview:disViewBg1];
    UILabel *userNameTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 50)];
    userNameTitleLabel.text=@"姓名";
    userNameTitleLabel.backgroundColor=[UIColor clearColor];
    [userNameTitleLabel setTextColor:[UIColor colorWithRed:100.00/255 green:100.00/255 blue:100.00/255 alpha:1]];
    userNameTitleLabel.font=[UIFont systemFontOfSize:14];
    [userNameView addSubview:userNameTitleLabel];
    
    
    setUserNameButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userNameTitleLabel.frame)+5,0, userNameView.frame.size.width-CGRectGetMaxX(userNameTitleLabel.frame), 50)];
    //
    setUserNameButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
    [setUserNameButton setTitleColor:[UIColor colorWithRed:170.00/255 green:170.00/255 blue:170.00/255 alpha:1] forState:UIControlStateNormal];
    setUserNameButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [setUserNameButton setTitle:self.contactData.nickName forState:UIControlStateNormal];
    [userNameView addSubview:setUserNameButton];
    [mainView addSubview:userNameView];
    frame=userNameView.frame;
    
    UIView *telView=[[UIView alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(frame), kScreenWidth-40, 50)];
    UIImageView *disViewBg2=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,telView.frame.size.width, 50)];
    disViewBg2.image=[UIImage imageNamed:@"SLBaseChat.bundle/bg_cell.png"];
    [telView addSubview:disViewBg2];
    UILabel *telTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 50)];
    telTitleLabel.text=@"联系电话";
    telTitleLabel.backgroundColor=[UIColor clearColor];
    [telTitleLabel setTextColor:[UIColor colorWithRed:100.00/255 green:100.00/255 blue:100.00/255 alpha:1]];
    telTitleLabel.font=[UIFont systemFontOfSize:14];
    [telView addSubview:telTitleLabel];
    
    
    telButton = [[RTLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(telTitleLabel.frame)+5,0, telView.frame.size.width-CGRectGetMaxX(telTitleLabel.frame),46)];
    telButton.lineBreakMode=NSLineBreakByCharWrapping;
    telButton.backgroundColor=[UIColor clearColor];
    
    
    NSString *tempTel=[BCCommon ValiString:self.contactData.mobile];
    if (tempTel.length>0) {
        tempTel= [NSString stringWithFormat:@"<a href='telprompt://%@'>%@</a>",tempTel,tempTel];
    }
    
    [telButton setText:tempTel];
    [telButton setTextColor:[UIColor colorWithRed:170.00/255 green:170.00/255 blue:170.00/255 alpha:1]];
    telButton.font=[UIFont systemFontOfSize:14];
    [telButton setDelegate:self];
    
    CGSize optimumSizeTel = [telButton optimumSize];
    
    NSInteger floatHeight1=(50-optimumSizeTel.height)/2.0;
    
    telButton.frame=CGRectMake(CGRectGetMaxX(telTitleLabel.frame)+5,floatHeight1, telView.frame.size.width-CGRectGetMaxX(telTitleLabel.frame),optimumSizeTel.height);

    [telView addSubview:telButton];
    
    
    [mainView addSubview:telView];
    
    frame=telView.frame;
    
   
    UIView *emailView=[[UIView alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(frame), kScreenWidth-40,50)];
    UIImageView *disViewBg3=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,emailView.frame.size.width,50)];
    disViewBg3.image=[UIImage imageNamed:@"SLBaseChat.bundle/bg_cell.png"];
    [emailView addSubview:disViewBg3];
    UILabel *emailTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 50)];
    emailTitleLabel.text=@"Email";
    emailTitleLabel.lineBreakMode=NSLineBreakByCharWrapping;
    emailTitleLabel.numberOfLines = 0;
    emailTitleLabel.backgroundColor=[UIColor clearColor];
    [emailTitleLabel setTextColor:[UIColor colorWithRed:100.00/255 green:100.00/255 blue:100.00/255 alpha:1]];
    emailTitleLabel.font=[UIFont systemFontOfSize:14];
    [emailView addSubview:emailTitleLabel];
    
    
    emailButton = [[RTLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(emailTitleLabel.frame)+5,0, emailView.frame.size.width-CGRectGetMaxX(emailTitleLabel.frame)-20,46)];
//    emailButton.text=self.contactData.email;
    emailButton.lineBreakMode=NSLineBreakByCharWrapping;
    emailButton.backgroundColor=[UIColor clearColor];
    
    
    NSString *tempEmail=[BCCommon ValiString:self.contactData.email];
    if (tempEmail.length>0) {
        tempEmail= [NSString stringWithFormat:@"<a href='mailto://%@'>%@</a>",tempEmail,tempEmail];
    }
    
    [emailButton setText:tempEmail];
    [emailButton setTextColor:[UIColor colorWithRed:170.00/255 green:170.00/255 blue:170.00/255 alpha:1]];
    emailButton.font=[UIFont systemFontOfSize:14];
    [emailButton setDelegate:self];
    
    CGSize optimumSizeEmail = [emailButton optimumSize];
   
   NSInteger floatHeight2=(50-optimumSizeEmail.height)/2.0;
    
    
    [emailButton setFrame:CGRectMake(CGRectGetMaxX(emailTitleLabel.frame)+5,floatHeight2, emailView.frame.size.width-CGRectGetMaxX(emailTitleLabel.frame)-20,optimumSizeEmail.height)];
    [emailView addSubview:emailButton];
    
    
    [mainView addSubview:emailView];
    frame=emailView.frame;
    
    UIButton *chatButton = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(frame)+50, kScreenWidth-40, 40)];
    [chatButton setBackgroundImage:[UIImage imageNamed:@"SLBaseChat.bundle/btn_common_big_normal"] forState:UIControlStateNormal];
    [chatButton setTitle:@"开始对话" forState:UIControlStateNormal];
    chatButton.titleLabel.font=[UIFont systemFontOfSize:16];
    //[chatButton addTarget:self action:@selector(beginChat) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:chatButton];
    frame=chatButton.frame;

    
    
    
    [self showContactInfoData];
    // Do any additional setup after loading the view.
}
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url{
    
   [[UIApplication sharedApplication] openURL:url];

    
}
-(void)downloadHeadImage:(NSString *)imageName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *savePath=[BCCommon getUserHeadImageSavePath:self.loginData.userId];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:savePath]) {
        [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/portraits/%@",[BaseChatSDK defaultCore].BCWebServiceURL,imageName]];
    
    __block ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
    
    [request setDownloadDestinationPath:[savePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",imageName]]];
    
    [request setShouldContinueWhenAppEntersBackground:YES];
    request.defaultResponseEncoding=NSUTF8StringEncoding;
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request setRequestMethod:@"GET"];
    [request addRequestHeader:@"Authorization" value:self.loginData.loginToken];
    
    [request setTimeOutSeconds:120];
    
    [request setNumberOfTimesToRetryOnTimeout:3];
    
    [request setCompletionBlock:^{
        [headButton setImage:[BCCommon getUserHeadImageFromImageName:[NSString stringWithFormat:@"%@.jpg",self.contactData.contactHead] withUserId:self.loginData.userId ] forState:UIControlStateNormal];
    }];
    [request setFailedBlock:^{
        [headButton setImage:[UIImage imageNamed:@"SLBaseChat.bundle/user_default_head.png"] forState:UIControlStateNormal];
    }];
    [request startAsynchronous];
    
    
}

-(void)showContactInfoData{
    
    NSString *urlString=[NSString stringWithFormat:@"%@/users/%@/",[BaseChatSDK defaultCore].BCWebServiceURL,self.contactData.contactId];
    NSLog(@"%@",urlString);
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.defaultResponseEncoding=NSUTF8StringEncoding;
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"Authorization" value:self.loginData.loginToken];
    [request setRequestMethod:@"GET"];
    
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
        
        
        NSString *tempName=[responseObject objectForKey:@"nickname"];
        [setUserNameButton setTitle:tempName forState:UIControlStateNormal];
        NSString *pinYinResult=[NSString string];
        for(int j=0;j<tempName.length;j++){
            NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([tempName characterAtIndex:j])]uppercaseString];
            
            pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
        }
        
        NSString *tempTel=[BCCommon ValiString:[responseObject objectForKey:@"mobile"]];
        if (tempTel.length>0) {
            tempTel= [NSString stringWithFormat:@"<a href='telprompt://%@'>%@</a>",tempTel,tempTel];
        }
        
        [telButton setText:tempTel];
        CGSize optimumSizeTel = [telButton optimumSize];
        
        NSInteger floatHeight1=(50-optimumSizeTel.height)/2.0;
        
        telButton.frame=CGRectMake(telButton.frame.origin.x,floatHeight1, telButton.frame.size.width,optimumSizeTel.height);
        
        
        
        NSString *tempEmail=[BCCommon ValiString:[responseObject objectForKey:@"email"]];
        if (tempEmail.length>0) {
            tempEmail= [NSString stringWithFormat:@"<a href='mailto://%@'>%@</a>",tempEmail,tempEmail];
        }
        
        [emailButton setText:tempEmail];
        
        CGSize optimumSizeEmail = [emailButton optimumSize];
        
        NSInteger floatHeight2=(50-optimumSizeEmail.height)/2.0;

        emailButton.frame=CGRectMake(emailButton.frame.origin.x,floatHeight2, emailButton.frame.size.width,optimumSizeEmail.height);
        [[ContactDAO defaultInstance] update:[responseObject objectForKey:@"_id"] withName:[responseObject objectForKey:@"userName"] withHead:[responseObject objectForKey:@"portraitUrl"] withConatctPinY:pinYinResult withRemark:@"" withNickName:[responseObject objectForKey:@"nickname"] withEmail:[responseObject objectForKey:@"email"] withMobile:[responseObject objectForKey:@"mobile"] withDataUser:self.loginData.userId];

    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}


- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
