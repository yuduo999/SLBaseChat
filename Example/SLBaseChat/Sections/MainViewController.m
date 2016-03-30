//
//  ViewController.m
//  ChatDemo
//
//  Created by song.zhang on 16/3/9.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import "MainViewController.h"
#import "MoreViewController.h"
#import "DemoViewController.h"
#import <BaseChatSDK/BaseChatSDK.h>

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMainwindow];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setMainwindow
{
    NSMutableArray *controllers=[[NSMutableArray alloc] init];
    
    NSArray *item=[[NSArray alloc] initWithObjects:@"消息",@"待办",@"查询",@"业绩",@"更多",nil];
    for(int i=0;i<[item count];i++)
    {
        UIViewController *viewController;
        
        NSString *itemImage_1;
        NSString *itemImage_2;
        switch (i) {
            case 0:
                itemImage_1=@"BaseChatSDK.bundle/icon_tabbar_contact_normal";
                itemImage_2=@"BaseChatSDK.bundle/icon_tabbar_contact_selected";
                viewController=[[BCMessageMainViewController alloc] init];
                break;
                
            case 1:
                itemImage_1=@"BaseChatSDK.bundle/icon_tabbar_approve_normal";
                itemImage_2=@"BaseChatSDK.bundle/icon_tabbar_approve_selected";
                viewController=[[DemoViewController alloc] init];
                break;
            case 2:
                itemImage_1=@"BaseChatSDK.bundle/icon_dropdown_sort_normal";
                itemImage_2=@"BaseChatSDK.bundle/icon_dropdown_sort_selected";
                viewController=[[DemoViewController alloc] init];
                break;
            case 3:
                itemImage_1=@"BaseChatSDK.bundle/icon_tabbar_discovery";
                itemImage_2=@"BaseChatSDK.bundle/icon_tabbar_discovery_selected";
                viewController=[[DemoViewController alloc] init];
                break;
            default:
                itemImage_1=@"BaseChatSDK.bundle/icon_tabbar_more_normal";
                itemImage_2=@"BaseChatSDK.bundle/icon_tabbar_more_selected";
                viewController=[[MoreViewController alloc] init];
                break;
        }
        
        UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:viewController];
        [nav.navigationBar setBackgroundColor:[UIColor clearColor]];
        if (IOS7) {
            nav.tabBarItem.image = [[UIImage imageNamed:itemImage_1] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            nav.tabBarItem.selectedImage = [[UIImage imageNamed:itemImage_2] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        else {
            [nav.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:itemImage_2] withFinishedUnselectedImage:[UIImage imageNamed:itemImage_1]];
        }
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:NAVBAR_BG] forBarMetrics:UIBarMetricsDefault];
        
        nav.tabBarItem.title=[item objectAtIndex:i];
        [nav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        [nav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
        [nav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:00.00/255 green:201.00/255 blue:176.00/255 alpha:1], NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
        
        //nav.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3.0);
        nav.tabBarItem.tag=i;
        [controllers addObject:nav];
    }
    
    self.viewControllers=controllers;
    self.selectedIndex =1;
    
}

@end
