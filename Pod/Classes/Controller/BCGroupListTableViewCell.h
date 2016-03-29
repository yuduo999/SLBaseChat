//
//  GroupListTableViewCell.h
//  OAChat
//
//  Created by song.zhang on 15/5/26.
//  Copyright (c) 2015年 sino-life. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupEntity.h"
@interface BCGroupListTableViewCell : UITableViewCell{
  NSMutableArray *headArray;
}
@property(nonatomic,weak)UIImageView *groupHeadImage;
@property(nonatomic,weak)UILabel *groupNameLabel;
-(void)initData:(GroupEntity *)data withLoginToken:(NSString *)loginToken;
@end
