//
//  MoreViewController.m
//  ChatDemo
//
//  Created by song.zhang on 16/3/21.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import "MoreViewController.h"
#import <BaseChatSDK/BaseChatSDK.h>
#import "MoreMenuData.h"

#import "SVProgressHUD.h"

@interface MoreViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *tableDataView;
    NSMutableArray *dataList;
    NSString *updateUrl;
}
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:NAVBAR_BG] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,[UIFont fontWithName:@"Helvetica" size:18],UITextAttributeFont,nil] ];
    self.navigationItem.title=@"更多";
    
    
    dataList= [NSMutableArray array];
    
    NSMutableArray *temp001=[NSMutableArray array];
    
    MoreMenuData *data001=[[MoreMenuData alloc]init];
    data001.menuCode=@"001";
    data001.menuICO=nil;
    data001.menuName=@"通讯录查询";
    data001.orderBy=1;
    [temp001 addObject:data001];
    [dataList addObject:temp001];
    
    NSMutableArray *temp100=[NSMutableArray array];
    MoreMenuData *data101=[[MoreMenuData alloc]init];
    data101.menuCode=@"101";
    data101.menuICO=nil;
    data101.menuName=@"设置手势锁";
    data101.orderBy=1;
    [temp100 addObject:data101];
    
    MoreMenuData *data102=[[MoreMenuData alloc]init];
    data102.menuCode=@"102";
    data102.menuICO=nil;
    data102.menuName=@"二维码分享";
    data102.orderBy=2;
    [temp100 addObject:data102];
    
    MoreMenuData *data103=[[MoreMenuData alloc]init];
    data103.menuCode=@"103";
    data103.menuICO=nil;
    data103.menuName=@"扫扫二维码";
    data103.orderBy=3;
    [temp100 addObject:data103];
    
    MoreMenuData *data104=[[MoreMenuData alloc]init];
    data104.menuCode=@"104";
    data104.menuICO=nil;
    data104.menuName=@"日志查询";
    data104.orderBy=4;
    [temp100 addObject:data104];
    
    
    MoreMenuData *data105=[[MoreMenuData alloc]init];
    data105.menuCode=@"105";
    data105.menuICO=nil;
    data105.menuName=@"版本更新";
    data105.orderBy=5;
    [temp100 addObject:data105];
     [dataList addObject:temp100];
    
    NSMutableArray *temp201=[NSMutableArray array];
    
    MoreMenuData *data201=[[MoreMenuData alloc]init];
    data201.menuCode=@"201";
    data201.menuICO=nil;
    data201.menuName=@"退出登录";
    data201.orderBy=1;
    [temp201 addObject:data201];
    [dataList addObject:temp201];
    
    tableDataView=[[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width,self.view.frame.size.height-110) style:UITableViewStyleGrouped];
    tableDataView.dataSource=self;
    tableDataView.delegate=self;
    tableDataView.backgroundView=nil;
    tableDataView.backgroundColor=[UIColor clearColor];
    [self.view addSubview: tableDataView];
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dataList objectAtIndex:section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreMenuData *data=[[dataList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([data.menuCode isEqualToString:@"201"]) {
        [self loginOutIM];
    }
    // 动态取消表格选中效果
    [tableDataView performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:indexPath afterDelay:0.5];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    MoreMenuData *data=[[dataList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        cell.textLabel.backgroundColor=[UIColor clearColor];
        if ([data.menuCode isEqualToString:@"201"]) {
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
            [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
            cell.textLabel.textColor=[UIColor colorWithRed:174.00/255 green:30.00/255 blue:5.00/255 alpha:1];
        }else{
            [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            cell.textLabel.textAlignment=NSTextAlignmentLeft;
            cell.textLabel.textColor=[UIColor colorWithRed:132.00/255 green:132.00/255 blue:132.00/255 alpha:1];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    }
    cell.textLabel.text=data.menuName;
    cell.contentView.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)loginOutIM{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"退出提示"
                                                    message:@"确认退出当前登录么？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%zd",buttonIndex);
    if (buttonIndex==1) {
        NSString *token= [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
        [SVProgressHUD showWithStatus:NSLocalizedString(@"progress_vailding", nil)];
        [[BaseChatSDK defaultCore]loginOut:token];
        
    }
   
}

-(void)showIMLoginOutResult:(NSNotification *)notif{
    NSString *result=[notif object];
    NSLog(@"%@",result);
    [SVProgressHUD dismiss];
    LoginViewController *loginView=[[LoginViewController alloc] init];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:loginView];
    [UIApplication sharedApplication].delegate.window.rootViewController=nav;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showIMLoginOutResult:) name:NOTIFICATION_ON_IMLOGINOUT object:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:NOTIFICATION_ON_IMLOGINOUT];
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
