//
//  BaseNavigationController.m
//  SunnyWeiBo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseNavigationController.h"
#import "ThemeManager.h"
@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeDidChangeNotificationName object:nil];
    }
    return self;
}

- (void)themeDidChange:(NSNotification *)notification {
    [self loadImage];
}

- (void)loadImage {
    
    ThemeManager *manager = [ThemeManager shareInstance];
    //修改导航栏背景
    UIImage *image = [manager getThemeImage:@"mask_titlebar64.png"];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    //修改字体颜色
    UIColor *color = [manager getThemeColor:@"Mask_Title_color"];
    NSDictionary *attrDic = @{NSForegroundColorAttributeName:color};
    self.navigationBar.titleTextAttributes = attrDic;
    //修改视图背景
    //UIImage *bgImage = [manager getThemeImage:@"bg_home.jpg"];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    //第一次进工程时navigation显示顶部视图
    [self loadImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
