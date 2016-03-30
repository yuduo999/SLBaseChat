//
//  MenuData.h
//  mobileoa
//
//  Created by song.zhang on 14-10-9.
//  Copyright (c) 2014年 Sino-life. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoreMenuData : NSObject
{
    NSString *menuCode;
    NSString *menuName;
    NSString *menuICO;
    int orderBy;
}

@property(nonatomic,retain)NSString *menuCode;
@property(nonatomic,retain)NSString *menuName;
@property(nonatomic,retain)NSString *menuICO;
@property(nonatomic)int orderBy;
@end
