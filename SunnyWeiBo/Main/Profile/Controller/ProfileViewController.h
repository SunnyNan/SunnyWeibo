//
//  ProfileViewController.h
//  SunnyWeiBo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseViewController.h"
#import "SinaWeiboRequest.h"
#import "WeiboTable.h"
#import "WeiboModel.h"
#import "WeiboViewFrameLaout.h"
#import "ProfileView.h"
#import "ProfileTableView.h"
@interface ProfileViewController : BaseViewController<SinaWeiboRequestDelegate>{
    ProfileTableView *_weiboTable;
    ProfileView  *_profileView;

}
@end
