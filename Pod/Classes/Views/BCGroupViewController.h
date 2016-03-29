//
//  BCGroupViewController.h
//  BaseChatSDK
//
//  Created by song.zhang on 16/3/25.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupEntity.h"
#import "LoginUserEntity.h"
@interface BCGroupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
-(id)initWithData:(LoginUserEntity *)loginData;
@property(nonatomic,retain)LoginUserEntity *loginData;
@property(nonatomic ,retain)NSMutableArray *dataList;
@property(nonatomic ,strong)UITableView *dataTableView;
@end
