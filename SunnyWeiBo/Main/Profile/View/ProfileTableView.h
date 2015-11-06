//
//  ProfileTableView.h
//  SunnyWeiBo
//
//  Created by mac on 15/10/14.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileView.h"
#import "WeiboModel.h"
@interface ProfileTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
{
    ProfileView *_userView;
    UIView *_theTableHeaderView;
    WeiboModel  *_weiboModel;
}
@property (nonatomic,strong)NSArray *data;

@end
