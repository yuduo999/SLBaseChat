//
//  ContactListTableViewCell.h
//  OAChat
//
//  Created by song.zhang on 15/4/8.
//  Copyright (c) 2015年 sino-life. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactEntity.h"

@interface BCContactTableViewCell : UITableViewCell
@property(nonatomic,weak) UIImageView *contactImage;
@property(nonatomic,weak) UILabel *contactNameLabel;
-(void)initData:(ContactEntity *)data withDataUser:(NSString *)dataUser withLoginToken:(NSString *)loginToken;
@end
