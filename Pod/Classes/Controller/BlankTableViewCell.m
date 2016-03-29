//
//  BlankTableViewCell.m
//  mobileoa
//
//  Created by song.zhang on 14/12/29.
//  Copyright (c) 2014年 Sino-life. All rights reserved.
//

#import "BlankTableViewCell.h"

@implementation BlankTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)initData:(NSString *)title{

    UILabel *serviceName=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 60)];
    serviceName.backgroundColor=[UIColor clearColor];
    serviceName.text=title;
    serviceName.textAlignment=NSTextAlignmentCenter;
    serviceName.font=[UIFont boldSystemFontOfSize:16];
    serviceName.textColor=[UIColor colorWithRed:132.00/255 green:132.00/255 blue:132.00/255 alpha:1];
    [self addSubview:serviceName ];
    
}
-(void)initData:(NSString *)title frame:(CGRect)frame{

    
    UILabel *serviceName=[[UILabel alloc] initWithFrame:frame];
    serviceName.backgroundColor=[UIColor clearColor];
    serviceName.text=title;
    serviceName.textAlignment=NSTextAlignmentCenter;
    serviceName.font=[UIFont boldSystemFontOfSize:16];
    serviceName.textColor=[UIColor colorWithRed:132.00/255 green:132.00/255 blue:132.00/255 alpha:1];
    [self addSubview:serviceName ];
}
@end
