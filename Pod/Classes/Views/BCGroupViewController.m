//
//  BCGroupViewController.m
//  BaseChatSDK
//
//  Created by song.zhang on 16/3/25.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import "BCGroupViewController.h"
#import "BaseChatSDK.h"
#import "BCCommon.h"
#import "BlankTableViewCell.h"
#import "BCGroupListTableViewCell.h"
#import "GroupDAO.h"
@interface BCGroupViewController ()

@end

@implementation BCGroupViewController
-(id)initWithData:(LoginUserEntity *)loginData {
    self.loginData=loginData;
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
    self.navigationItem.title=@"群聊";
    UIButton *backBtn =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"SLBaseChat.bundle/nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    self.dataTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64+KNavigationBarHeight) style:UITableViewStylePlain];
    
    self.dataTableView.dataSource=self;
    self.dataTableView.delegate=self;
    self.dataTableView.backgroundView=nil;
    self.dataTableView.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview: self.dataTableView];
    [[BaseChatSDK defaultCore]getGroupList:self.loginData.loginToken withVersion:@(0) withDataUser:self.loginData.userId];
    [self bindGroupList];
    // Do any additional setup after loading the view.
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataList.count==0) {
        return 1;
    }
    return [self.dataList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataList.count==0) {
        return;
    }
    [tableView performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:indexPath afterDelay:0];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataList.count==0) {
        BlankTableViewCell *cell=[[BlankTableViewCell alloc] init];
        [cell initData:@"暂无数据" frame:CGRectMake(0, 0, kScreenWidth, 80)];
        return cell;
        
    }
    GroupEntity *data=self.dataList[indexPath.row];
    NSString *TableSampleIdentifier = [NSString stringWithFormat:@"%@",data.groupId];
    //    用TableSampleIdentifier表示需要重用的单元
    BCGroupListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    //    如果如果没有多余单元，则需要创建新的单元
    if (cell == nil) {
        cell = [[BCGroupListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
        
        
        cell.contentView.backgroundColor=[UIColor clearColor];
        cell.selectedBackgroundView =[[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:200.00/255 green:200.00/255 blue:200.00/255 alpha:0.3];
    }
    [cell initData:data withLoginToken:self.loginData.loginToken];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.dataList.count==0) {
        return;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"退出群";
}

-(void)bindGroupList{
    self.dataList=[[GroupDAO defaultInstance]getAllGroup:self.loginData.userId];
    [self.dataTableView reloadData];
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindGroupList) name:NOTIFICATION_ON_REFRESH_GROUP object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:NOTIFICATION_ON_REFRESH_GROUP];
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
