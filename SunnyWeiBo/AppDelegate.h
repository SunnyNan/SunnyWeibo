//
//  AppDelegate.h
//  SunnyWeiBo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "Common.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,SinaWeiboDelegate>

@property (strong, nonatomic) SinaWeibo *sinaWeibo;

@property (strong, nonatomic) UIWindow *window;



@end

