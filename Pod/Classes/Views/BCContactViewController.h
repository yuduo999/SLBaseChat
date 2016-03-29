//
//  BCContactViewController.h
//  BaseChatSDK
//
//  Created by song.zhang on 16/3/24.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactEntity.h"
#import "LoginUserEntity.h"
@interface BCContactViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{

    NSMutableArray *dataList;
    NSMutableArray *dataSection;
}
-(id)initWithData:(LoginUserEntity *)loginData;
@property(nonatomic,retain)LoginUserEntity *loginData;
@property(nonatomic,strong)UITableView *dataTableView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;

@end
