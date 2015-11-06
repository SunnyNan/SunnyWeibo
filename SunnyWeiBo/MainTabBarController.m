//
//  MainTabBarController.m
//  SunnyWeiBo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseViewController.h"
#import "Common.h"
#import "ThemeImageView.h"
#import "ThemeButton.h"
#import "ThemeLabel.h"
#import "AppDelegate.h"
@interface MainTabBarController ()
{
    ThemeImageView *_selectedImageView;
    ThemeImageView *_badgeImageView;
    ThemeLabel *_badgeLabel;
    
}
@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    //1.加载子控制视图
    [self _creatSubControllers];
    //2.创建tabBar
    [self _creatTabBar];
    
    //3.开启定时器,请求unread_count接口 获取未读微博、新粉丝数量、新评论。。。
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
}

- (void)_creatSubControllers {
    NSArray *names = @[@"Home",@"Profile",@"Discover",@"More"];
    NSMutableArray *navigationArray = [[NSMutableArray alloc]initWithCapacity:5];
    for (int i = 0; i < 4; i ++) {
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:names[i] bundle:nil];
        
        BaseViewController *navigationC = [storyBoard instantiateInitialViewController];
        [navigationArray addObject:navigationC];
        
    }
    self.viewControllers = navigationArray;
}

- (void)_creatTabBar {
    //移除tabBarButton
    for (UIView *view in self.tabBar.subviews) {
        Class cls = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:cls]) {
            [view removeFromSuperview];
        }
    }
    //背景图片
    ThemeImageView *bgImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
    bgImageView.imageName = @"mask_navbar.png";
    //bgImageView.image = [UIImage imageNamed:@"Skins/cat/mask_navbar.png"];
    [self.tabBar addSubview:bgImageView];
    //选中图片
    _selectedImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth / 5, 49)];
    //_selectedImageView.image = [UIImage imageNamed:@"Skins/cat/home_bottom_tab_arrow.png"];
    _selectedImageView.imageName = @"home_bottom_tab_arrow.png";
    [self.tabBar addSubview:_selectedImageView];
    //按钮图片
    CGFloat width = kScreenWidth / 4;

    NSArray *imageNames = @[@"home_tab_icon_1.png",
                            @"home_tab_icon_4.png",
                            @"home_tab_icon_3.png",
                            @"home_tab_icon_5.png"];
    
    for (int i = 0; i < 4; i ++) {
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(i * width, 0, width, 49)];
        //[button setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        button.normalImageName = imageNames[i];
        button.tag = i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:button];
        
    }
    
}

- (void)buttonAction:(UIButton *)button {
    [UIView animateWithDuration:.3 animations:^{
        _selectedImageView.center = button.center;
    }];
    self.selectedIndex = button.tag;
}


#pragma mark - 未读消息个数显示
- (void)timerAction:(NSTimer *)timer {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
    [sinaWeibo requestWithURL:unread_count params:nil httpMethod:@"GET" delegate:self];
    
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    
    NSNumber *status = [result objectForKey:@"status"];
    NSInteger count = [status integerValue];
    
    CGFloat buttonWidth = kScreenWidth / 5;
    
    
    if (_badgeImageView == nil) {
        _badgeImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(buttonWidth-32, 0, 32, 32)];
        _badgeImageView.imageName = @"number_notify_9.png";
        
        [self.tabBar addSubview:_badgeImageView];
        _badgeLabel = [[ThemeLabel alloc] initWithFrame:_badgeImageView.bounds];
        _badgeLabel.backgroundColor = [UIColor clearColor];
        _badgeLabel.colorName = @"Timeline_Notice_color";
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.font = [UIFont systemFontOfSize:13];
        [_badgeImageView addSubview:_badgeLabel];
        
    }
    if (count == 0) {
        _badgeImageView.hidden = YES;
    }else if(count > 99){
        _badgeImageView.hidden = NO;
        _badgeLabel.text = @"99";
        
    }else{
        _badgeImageView.hidden = NO;
        _badgeLabel.text = [NSString stringWithFormat:@"%li",count];
        
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
