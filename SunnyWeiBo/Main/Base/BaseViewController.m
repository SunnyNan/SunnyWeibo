//
//  BaseViewController.m
//  SunnyWeiBo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseViewController.h"
#import "ThemeManager.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerController.h"
#import "MBProgressHUD.h"

@interface BaseViewController ()
{
    UIButton *_rightButton;
    UIButton *_leftButton;
    MBProgressHUD *_hud;
    UIView *_tipView;
    UIWindow *_tipWindow;
}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    [self loadImage];
    //[self setNavigationItem];

    
}
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)themeDidChange:(NSNotification *)notification {
    [self loadImage];
    [self setNavigationItem];
}
- (void)setNavigationItem {
    
    ThemeManager *manager = [ThemeManager shareInstance];
    //左侧按钮图标设置
    UIImage *image1 = [manager getThemeImage:@"button_title.png"];
    UIImage *image2 = [manager getThemeImage:@"group_btn_all_on_title.png"];
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 40, 30);
    [_leftButton setImage:image1 forState:UIControlStateNormal];
    [_leftButton setImage:image2 forState:UIControlStateSelected];
    [_leftButton addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_leftButton];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    //右侧按钮图标设置
    UIImage *image3 = [manager getThemeImage:@"button_icon_plus.png"];
    UIImage *image4 = [manager getThemeImage:@"button_m.png"];
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 60, 40);
    [_rightButton setImage:image3 forState:UIControlStateNormal];
    [_rightButton setImage:image4 forState:UIControlStateSelected];
    [_rightButton addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setAction)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction)];
    
}

- (void)setAction {
    MMDrawerController *mmDrawer = self.mm_drawerController;
    [mmDrawer openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)editAction {
    MMDrawerController *mmDrawer = self.mm_drawerController;
    [mmDrawer openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (void)setBgImage {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadImage) name:kThemeDidChangeNotificationName object:nil];
    [self loadImage];
}
- (void)loadImage{
    
    ThemeManager *manager = [ThemeManager shareInstance];
    //修改视图背景
    UIImage *bgImage = [manager getThemeImage:@"bg_home.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
}

#pragma mark - 进度显示
//01.自己实现方法
- (void)showLoding:(BOOL)show {
    if (_tipView == nil) {
        _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight/2-30, kScreenWidth, 20)];
        _tipView.backgroundColor = [UIColor clearColor];
        
        //01. activity
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.tag = 100;
        [_tipView addSubview:activityView];
        
        //02.Label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"正在加载...";
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor blackColor];
        //调整大小并移动接收者视图大小所以他包含了他的子视图
        [label sizeToFit];
        [_tipView addSubview:label];
        
        label.left = (kScreenWidth-label.width)/2;
        activityView.right = label.left-5;

    }
    if (show) {
        
        UIActivityIndicatorView *activiyView =(UIActivityIndicatorView*) [_tipView viewWithTag:100];
        [activiyView startAnimating];
        [self.view addSubview:_tipView];
    }else{
        if (_tipView.superview) {
            UIActivityIndicatorView *activiyView = (UIActivityIndicatorView*)[_tipView viewWithTag:100];
            [activiyView stopAnimating];
            [_tipView removeFromSuperview];
        }
    }
}

#pragma mark - 进度条显示
- (void)showTipTitle:(NSString *)title show:(BOOL)show {
    if (_tipWindow == nil) {
        _tipWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _tipWindow.windowLevel = UIWindowLevelStatusBar;
        _tipWindow.backgroundColor = [UIColor blackColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:_tipWindow.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.tag = 10;
        [_tipWindow addSubview:label];
    }
    UILabel *label = (UILabel *)[_tipWindow viewWithTag:10];
    label.text = title;
    if (show) {
        [_tipWindow setHidden:NO];
    }else {
        [self performSelector:@selector(hideTipWindow) withObject:nil afterDelay:1];
    }
}

- (void)hideTipWindow {
    [_tipWindow setHidden:YES];
}
//02.第三方实现方法
- (void)showHud:(NSString *)title {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_hud show:YES];
    _hud.labelText = title;
    _hud.dimBackground = YES;//阴影

}

- (void)hideHud {
    [_hud hide:YES];
}

- (void)comleteHud:(NSString *)title {
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = title;
    [_hud hide:YES afterDelay:1.5];
}
@end
