//
//  BCContactViewController.m
//  BaseChatSDK
//
//  Created by song.zhang on 16/3/24.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import "BCContactViewController.h"
#import "BaseChatSDK.h"
#import "BCCommon.h"
#import "ContactDAO.h"
#import "pinyin.h"
#import "BCContactTableViewCell.h"
@interface BCContactViewController ()

@end

@implementation BCContactViewController

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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"SLBaseChat.bundle/bg_contact_tophead"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,[UIFont fontWithName:@"Helvetica" size:18],UITextAttributeFont,nil] ];
    self.title=@"联系人";
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
    
    if (IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.dataTableView.sectionIndexBackgroundColor=[UIColor clearColor];
        
        self.dataTableView.sectionIndexColor = [UIColor colorWithRed:100.00/255 green:100.00/255 blue:100.00/255 alpha:1.0];
    }
   
    [[BaseChatSDK defaultCore]getContactList:self.loginData.loginToken withVersion:self.loginData.contactVersion withDataUser:self.loginData.userId];
    
    [self bindContactList];
    // Do any additional setup after loading the view.
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self bindContactList];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        self.searchBar=[[UISearchBar alloc]init];
        //[self.searchBar sizeToFit];
        self.searchBar.backgroundColor=[UIColor colorWithWhite:0.97f alpha:1.0];
        self.searchBar.delegate=self;
        self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        
        return  self.searchBar;
    }
    UILabel *label = [UILabel new];
    label.text = [@"    " stringByAppendingString:dataSection[section]];
    label.backgroundColor = [UIColor colorWithWhite:0.97f alpha:1.0];
    label.textColor = [UIColor colorWithWhite:0.13f alpha:1.0];
    label.font = [UIFont boldSystemFontOfSize:14.0f];
    return label;
}
- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return YES;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return dataSection;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dataList objectAtIndex:section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 50;
    }
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 动态取消表格选中效果
    [tableView performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:indexPath afterDelay:0];
}




- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(dataList.count==0) {
        return;
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
   // ContactEntity *data=dataList[indexPath.section][indexPath.row];
    
    return @"删除";
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactEntity *data=dataList[indexPath.section][indexPath.row];
    NSString *TableSampleIdentifier = data.contactId;
    BCContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    //    如果如果没有多余单元，则需要创建新的单元
    if (cell == nil) {
        cell = [[BCContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
        
        cell.contentView.backgroundColor=[UIColor clearColor];
        cell.selectedBackgroundView =[[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:200.00/255 green:200.00/255 blue:200.00/255 alpha:0.3];
        
        
    }
    [cell initData:data withDataUser:self.loginData.userId withLoginToken:self.loginData.loginToken];
    
    return cell;
}
-(void)bindContactList{
     NSMutableArray *locationData=[[ContactDAO defaultInstance]getAllContact:self.loginData.userId];
    dataList=[NSMutableArray array];
    dataSection=[NSMutableArray array];
    [dataSection addObject:@"🔍"];
    NSMutableArray *tempData1=[[NSMutableArray alloc]init];
    [dataList addObject:tempData1];
    for (int n=0; n<locationData.count; n++) {
        ContactEntity *data=[locationData objectAtIndex:n];
        NSString *t=[data.contactPinY substringToIndex:1];
        if ([dataSection indexOfObject:t]==NSNotFound) {
            [dataSection addObject:t];
        }
    }
    
    for (int n=0; n<dataSection.count; n++) {
        NSMutableArray *tempData=[[NSMutableArray alloc]init];
        for (int m=0; m<locationData.count; m++) {
            ContactEntity *data=[locationData objectAtIndex:m];
            
            if ([[dataSection objectAtIndex:n] isEqualToString:[data.contactPinY substringToIndex:1]]) {
                [tempData addObject:data];
            }
        }
        if (tempData.count>0) {
            [dataList addObject:tempData];
        }
    }
    [self.dataTableView reloadData];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindContactList) name:NOTIFICATION_ON_REFRESH_CONTACT object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:NOTIFICATION_ON_REFRESH_CONTACT];
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
