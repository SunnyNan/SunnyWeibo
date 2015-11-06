//
//  RightViewController.m
//  SunnyWeiBo
//
//  Created by mac on 15/10/10.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "RightViewController.h"
#import "ThemeButton.h"
#import "ThemeManager.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "BaseNavigationController.h"
#import "SendViewController.h"
#import "LocationViewController.h"
@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBgImage];
    NSArray *imageNames = @[@"newbar_icon_1.png",
                            @"newbar_icon_2.png",
                            @"newbar_icon_3.png",
                            @"newbar_icon_4.png",
                            @"newbar_icon_5.png"];
    
    for (int i = 0; i < imageNames.count; i ++) {
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(12, 60 + (i * 50), 40, 40)];
        button.normalImageName = imageNames[i];
        
        button.tag = i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];

    }

}

- (void)buttonAction:(UIButton *)button {
    if (button.tag == 0) {
        // 发送微博
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
            // 弹出发送微博控制器
            
            SendViewController *senderVc = [[SendViewController alloc] init];
            senderVc.title = @"发送微博";
            
            
            // 创建导航控制器
            BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:senderVc];
            [self.mm_drawerController presentViewController:baseNav animated:YES completion:nil];
        }];
    }else if(button.tag == 4) {
        // 附近地点
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
            
            LocationViewController *vc = [[LocationViewController alloc] init];
            vc.title = @"附近商圈";
            
            // 创建导航控制器
            BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:vc];
            [self.mm_drawerController presentViewController:baseNav animated:YES completion:nil];
        }];
    }
        
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
