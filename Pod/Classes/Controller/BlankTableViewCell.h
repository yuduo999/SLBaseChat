//
//  BlankTableViewCell.h
//  mobileoa
//
//  Created by song.zhang on 14/12/29.
//  Copyright (c) 2014年 Sino-life. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BlankTableViewCell : UITableViewCell
-(void)initData:(NSString *)title;
-(void)initData:(NSString *)title frame:(CGRect)frame;
@property(nonatomic,weak)UILabel *titleLabel;
@end
