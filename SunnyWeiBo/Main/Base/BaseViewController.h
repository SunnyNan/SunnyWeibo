//
//  BaseViewController.h
//  SunnyWeiBo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)setNavigationItem;

- (void)setBgImage;

- (void)showHud:(NSString *)title;

- (void)hideHud;

- (void)comleteHud:(NSString *)title;

- (void)showTipTitle:(NSString *)title show:(BOOL)show;

@end
