//
//  BCPersonInfoViewController.h
//  BaseChatSDK
//
//  Created by song.zhang on 16/3/23.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactEntity.h"
#import "LoginUserEntity.h"
#import "RTLabel.h"
@interface BCPersonInfoViewController : UIViewController<RTLabelDelegate>{
    UIScrollView *mainView;
    UIButton *headButton;
    UIButton *setUserNameButton;
    RTLabel *emailButton;
    RTLabel *telButton;
    CGRect frame;

}
-(id)initWithData:(NSString *)userId withLoginUser:(LoginUserEntity *)loginData;
@property(nonatomic,retain)NSString *userId;
@property(nonatomic,retain)ContactEntity *contactData;
@property(nonatomic,retain)LoginUserEntity *loginData;
@end
