//
//  BCMessageMainViewController.m
//  BaseChat
//
//  Created by song.zhang on 16/3/9.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import "BCMessageMainViewController.h"
#import "LoginUserEntity.h"
#import "LoginUserDAO.h"
#import "GroupMemberDAO.h"
#import "GroupDAO.h"
#import "GroupEntity.h"
#import "BCCommon.h"
#import "BaseChatSDK.h"
#import "BCPersonInfoViewController.h"
#import "BCContactViewController.h"
#import "BCGroupViewController.h"
@interface BCMessageMainViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *sessionTableView;
    UIButton *userHeadButton;
    LoginUserEntity *user;
    UIView *toolsView;
    BOOL isShowAcction;
}
@property (nonatomic, strong) NSMutableArray* dataList;
@end

@implementation BCMessageMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"SLBaseChat.bundle/bg_contact_tophead"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,[UIFont fontWithName:@"Helvetica" size:16],UITextAttributeFont,nil] ];
    userHeadButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    
    [userHeadButton addTarget:self action:@selector(showUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:userHeadButton];

    self.navigationItem.leftBarButtonItem=leftBtnItem;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,20,20)];
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton setImage:[UIImage imageNamed:@"SLBaseChat.bundle/navibar_add_ico"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(showActionButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addGroupItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    UIButton *rightButton3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,30,20)];
    rightButton3.backgroundColor = [UIColor clearColor];
    [rightButton3 addTarget:self action:@selector(showIMContactList:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton3 setImage:[UIImage imageNamed:@"SLBaseChat.bundle/navibar_contacts_ico"] forState:UIControlStateNormal];
    
    UIBarButtonItem *showContactItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton3];
    
    
    UIButton *rightButton4 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,30,20)];
    rightButton4.backgroundColor = [UIColor clearColor];
     [rightButton4 addTarget:self action:@selector(showIMGroupList:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton4 setImage:[UIImage imageNamed:@"SLBaseChat.bundle/navibar_groups_ico"] forState:UIControlStateNormal];
    
    UIBarButtonItem *showGroupItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton4];
    
    NSArray *rightBtns=[NSArray arrayWithObjects:addGroupItem,showContactItem,showGroupItem, nil];
    
    self.navigationItem.rightBarButtonItems = rightBtns;

    
    sessionTableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    sessionTableView.dataSource=self;
    sessionTableView.delegate=self;
    [self.view addSubview:sessionTableView];
  
    
    NSString *userId= [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    
   user=  [[LoginUserDAO defaultInstance] getLoginUser:userId];
    
    NSLog(@"%@,%@",user.userName,user.userHead);
   
    
    [userHeadButton setBackgroundImage:[UIImage imageNamed:@"SLBaseChat.bundle/navibar_head_bg"] forState:UIControlStateNormal];
    [userHeadButton setImage:[UIImage imageNamed:@"SLBaseChat.bundle/icon_contact_list"] forState:UIControlStateNormal];
    
    
    userHeadButton.layer.masksToBounds = YES;
    userHeadButton.layer.cornerRadius =17.5;
    userHeadButton.layer.borderWidth = 1;
    userHeadButton.layer.borderColor = [[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.3] CGColor];
    
    if ([user.userHead isKindOfClass:[NSNull class]] || user.userHead.length == 0){
        [userHeadButton setImage:[UIImage imageNamed:@"BaseChatSDK.bundle/user_default_head.png"] forState:UIControlStateNormal];
        
    }else{
        
        NSString *filePath = [[BCCommon getUserHeadImageSavePath:user.userId] stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.jpg",user.userHead]];
        BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
        if (!blHave) {
            [self downloadOneHeadImage:user.userHead];
        }else{
            [userHeadButton setImage:[BCCommon getUserHeadImageFromImageName:[NSString stringWithFormat:@"%@.jpg",user.userHead] withUserId:user.userId] forState:UIControlStateNormal];
        }
        
    }
    toolsView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:toolsView];
    UIControl *touch = [[UIControl alloc]init];
    touch.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [toolsView addSubview:touch];
    UITapGestureRecognizer *retn = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddToolBarView)];
    [touch addGestureRecognizer:retn];
    
    UIImageView *taskInfoBg;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"SLBaseChat.bundle/navibar_tool_bg"];
    
    backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(23, 40.5, 23, 40.5)];
    taskInfoBg = [[UIImageView alloc] initWithImage:backgroundImage];
    
    [toolsView addSubview:taskInfoBg];
    
    NSMutableArray *toolsData=[[NSMutableArray alloc]init];
    NSDictionary *groupAddItem=[NSDictionary dictionaryWithObjectsAndKeys:@"SLBaseChat.bundle/navibar_addgroup_ico",@"itemIco",@"发起群聊",@"itemTitle",@"addGroup",@"itemKey", nil];
    [toolsData addObject:groupAddItem];
    NSDictionary *contactAddItem=[NSDictionary dictionaryWithObjectsAndKeys:@"SLBaseChat.bundle/navibar_search_icon",@"itemIco",@"添加联系人",@"itemTitle",@"addContact",@"itemKey", nil];
    [toolsData addObject:contactAddItem];
    NSDictionary *groupListItem=[NSDictionary dictionaryWithObjectsAndKeys:@"SLBaseChat.bundle/navibar_groups_ico",@"itemIco",@"我的群组",@"itemTitle",@"groupList",@"itemKey", nil];
    [toolsData addObject:groupListItem];
    
    NSDictionary *contactListItem=[NSDictionary dictionaryWithObjectsAndKeys:@"SLBaseChat.bundle/navibar_contacts_ico",@"itemIco",@"我的联系人",@"itemTitle",@"contactList",@"itemKey", nil];
    [toolsData addObject:contactListItem];
    
    NSDictionary *codeScanItem=[NSDictionary dictionaryWithObjectsAndKeys:@"SLBaseChat.bundle/ico_scan",@"itemIco",@"扫扫二维码",@"itemTitle",@"codeScanList",@"itemKey", nil];
    [toolsData addObject:codeScanItem];
    
    CGSize size=CGSizeMake(self.view.frame.size.width-140, 8);
    for (int n=0;n<toolsData.count;n++) {
        UIImage *imgBg=[UIImage imageNamed:[[toolsData objectAtIndex:n] objectForKey:@"itemIco"]];
        UIButton *itemButton=[[UIButton alloc] initWithFrame:CGRectMake(size.width, size.height, 138,40)];
        [itemButton setImage:imgBg forState:UIControlStateNormal];
        [itemButton setTitle:[[toolsData objectAtIndex:n] objectForKey:@"itemTitle"] forState:UIControlStateNormal];
        [itemButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [itemButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        itemButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
        itemButton.accessibilityIdentifier=[[toolsData objectAtIndex:n] objectForKey:@"itemKey"];
        itemButton.backgroundColor = [UIColor clearColor];
        
        [itemButton addTarget:self action:@selector(actionToolButton:) forControlEvents:UIControlEventTouchUpInside];
        
        NSLog(@"%f",itemButton.titleLabel.bounds.size.width);
        [itemButton setTitleEdgeInsets:UIEdgeInsetsMake( 0.0,16, 0.0,0.0)];
        //
        [itemButton setImageEdgeInsets:UIEdgeInsetsMake(0.0,8,0.0,0)];
        [toolsView addSubview:itemButton];
        if (n+1<toolsData.count) {
            UIView *splineView=[[UIView alloc]initWithFrame:CGRectMake(size.width+35, size.height+40, 80, 0.6)];
            splineView.alpha=0.6;
            splineView.backgroundColor=[UIColor grayColor];
            [toolsView addSubview:splineView];
            
        }
        size=CGSizeMake(size.width, size.height+41);
    }
    [taskInfoBg setFrame:CGRectMake(self.view.frame.size.width-142,0, 135,size.height+5)];
    
    
    toolsView.frame=CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height-64);
    toolsView.backgroundColor = WINDOW_COLOR;
    
    [toolsView setHidden:YES];
    [[BaseChatSDK defaultCore]getContactList:user.loginToken withVersion:user.contactVersion withDataUser:user.userId];
    
}
-(void)showUserInfo:(UIButton *)sendor{
    NSLog(@"%@,%@,%@",user.userName,user.userHead,user.loginToken);
    BCPersonInfoViewController *vc=[[BCPersonInfoViewController alloc]initWithData:user.userId withLoginUser:user];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)showIMGroupList:(UIButton *)sendor{
    BCGroupViewController *vc=[[BCGroupViewController alloc]initWithData:user];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showIMContactList:(UIButton *)sendor{
    BCContactViewController *vc=[[BCContactViewController alloc]initWithData:user];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)actionToolButton:(UIButton *)sendor{
    

    [self hiddToolBarView];
}
-(void)showActionButton:(UIButton *)sendor{
    
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    [toolsView setHidden:NO];
    
    [UIView commitAnimations];
    isShowAcction=YES;
}

-(void)hiddToolBarView{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [toolsView setHidden:YES];
    } completion:^(BOOL finished) {
        isShowAcction=YES;
    }];
}
-(BOOL)isExistUserHeadImage:(NSString *)imageName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [[BCCommon getUserHeadImageSavePath:user.userId] stringByAppendingPathComponent:imageName];
    return ([fileManager fileExistsAtPath:filePath]==YES);
}

-(void)downloadOneHeadImage:(NSString *)imageName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *savePath=[BCCommon getUserHeadImageSavePath:user.userId];
    
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
    [request addRequestHeader:@"Authorization" value:user.loginToken];
    
    [request setTimeOutSeconds:120];
    
    [request setNumberOfTimesToRetryOnTimeout:3];
    
    [request setCompletionBlock:^{
        [userHeadButton setImage:[BCCommon getUserHeadImageFromImageName:[NSString stringWithFormat:@"%@.jpg",imageName] withUserId:user.userId] forState:UIControlStateNormal];
    }];
    [request setFailedBlock:^{
        [userHeadButton setImage:[UIImage imageNamed:@"user_default_head.png"] forState:UIControlStateNormal];
    }];
    [request startAsynchronous];
    
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TeamTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
   
    
    
    GroupEntity *playerObject = [self.dataList objectAtIndex:indexPath.row];
    cell.imageView.backgroundColor = [UIColor redColor];
    cell.textLabel.text = playerObject.groupName;
    cell.detailTextLabel.text = playerObject.groupId;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}
-(void)viewDidAppear:(BOOL)animated{
    
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
