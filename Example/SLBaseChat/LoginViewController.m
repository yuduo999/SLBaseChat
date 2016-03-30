//
//  LoginViewController.m
//  ChatDemo
//
//  Created by song.zhang on 16/3/18.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import "LoginViewController.h"
#import <BaseChatSDK/BaseChatSDK.h>
#import "MainViewController.h"
#import "SVProgressHUD.h"
#import "MessageBox.h"

@interface LoginViewController ()
@property(nonatomic,retain)UITextField *loginNameTextView;
@property(nonatomic,retain)UITextField *passwordTextView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 添加屏幕点击事件
    UIControl *touch = [[UIControl alloc]init];
    touch.frame = CGRectMake(0,64, self.view.frame.size.width, self.view.frame.size.height-64);
    [self.view addSubview:touch];
    UITapGestureRecognizer *retn = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard)];
    [touch addGestureRecognizer:retn];
    if (IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:NAVBAR_BG] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,[UIFont fontWithName:@"Helvetica" size:18],UITextAttributeFont,nil] ];
    self.title=@"富德移动办公";
    
    self.loginNameTextView=[[UITextField alloc]initWithFrame:CGRectMake(30, 30, kScreenWidth-60, 40)];
    self.loginNameTextView.placeholder=NSLocalizedString(@"form_account_placeholder", nil);
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    
    self.loginNameTextView.leftView = paddingView;
    
    self.loginNameTextView.leftViewMode = UITextFieldViewModeAlways;
   
    
    
    self.loginNameTextView.background=[UIImage imageNamed:@"BaseChatSDK.bundle/input_text_normal"];
    [self.loginNameTextView setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [self.loginNameTextView setTextColor:[UIColor colorWithRed:134.00/255 green:134.00/255 blue:134.00/255 alpha:1]];
    self.loginNameTextView.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.loginNameTextView];
    
    
    self.passwordTextView=[[UITextField alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.loginNameTextView.frame)+20, kScreenWidth-60, 40)];
    self.passwordTextView.placeholder=NSLocalizedString(@"form_password_placeholder", nil);
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.passwordTextView.leftView = paddingView1;
    
    self.passwordTextView.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextView.returnKeyType=UIReturnKeyDone;
    self.passwordTextView.secureTextEntry=YES;
    self.passwordTextView.background=[UIImage imageNamed:@"BaseChatSDK.bundle/input_text_normal"];
    [self.passwordTextView setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [self.passwordTextView setTextColor:[UIColor colorWithRed:134.00/255 green:134.00/255 blue:134.00/255 alpha:1]];
    self.passwordTextView.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.passwordTextView];
    if (!IOS7) {
        self.loginNameTextView.contentHorizontalAlignment=NSTextAlignmentCenter;
        self.loginNameTextView.contentVerticalAlignment=NSTextAlignmentLeft;
        self.passwordTextView.contentHorizontalAlignment=NSTextAlignmentCenter;
        self.passwordTextView.contentVerticalAlignment=NSTextAlignmentLeft;
    }
    UIButton *loginButton=[[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.passwordTextView.frame)+30, kScreenWidth-60, 45)];
    [loginButton setTitle:NSLocalizedString(@"form_login_button", nil) forState:UIControlStateNormal];
    loginButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:16];
    [loginButton addTarget:self action:@selector(loginIMAction:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"BaseChatSDK.bundle/btn_common_big_normal"] forState:UIControlStateNormal];
    
    [self.view addSubview:loginButton];
    
    [[BaseChatSDK defaultCore] setBCWebServiceURL:@"https://oim.sino-life.com:1865/im-web-server/v1"];
    // Do any additional setup after loading the view.
}
- (void)hiddenKeyBoard
{
    [self.loginNameTextView resignFirstResponder];
    [self.passwordTextView resignFirstResponder];
}

-(void)loginIMAction:(id)sendor{
    if ([self.loginNameTextView.text isKindOfClass:[NSNull class]] || self.loginNameTextView.text.length == 0){
        [MessageBox alert:NSLocalizedString(@"form_account_placeholder", nil)];
        return;
    }
    
    if ([self.loginNameTextView.text isKindOfClass:[NSNull class]] || self.loginNameTextView.text.length == 0){
        [MessageBox alert:NSLocalizedString(@"form_password_placeholder", nil)];
        return;
    }
    [SVProgressHUD showWithStatus:NSLocalizedString(@"progress_vailding", nil)];
    [[BaseChatSDK defaultCore]login:self.loginNameTextView.text withPassword:self.passwordTextView.text withDeviceToken:@"" withAppKey:@"im"];
    
}
-(void)showIMLoginResult:(NSNotification *)notif{
    NSDictionary *result=[notif object];
    NSLog(@"%@",result);
    [SVProgressHUD dismiss];
    if ([[result objectForKey:@"result"] isEqualToString:@"Y"]) {
        MainViewController *vc=[[MainViewController alloc]init];
        [[NSUserDefaults standardUserDefaults] setObject:[result objectForKey:@"userId"] forKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setObject:[result objectForKey:@"token"] forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
       [UIApplication sharedApplication].delegate.window.rootViewController=vc;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showIMLoginResult:) name:NOTIFICATION_ON_IMLOGIN object:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:NOTIFICATION_ON_IMLOGIN];
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
