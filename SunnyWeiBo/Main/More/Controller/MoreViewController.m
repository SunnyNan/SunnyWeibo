//
//  MoreViewController.m
//  SunnyWeiBo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreTableViewCell.h"
#import "AppDelegate.h"
#import "MoreTableViewController.h"
#import "SinaWeibo.h"
static NSString *moreCellId = @"moreCellId";

@interface MoreViewController ()<UITableViewDelegate,UITableViewDataSource,SinaWeiboRequestDelegate>

@end

@implementation MoreViewController{
    UITableView *_tableView;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self creatTableView];
    
}

//每次出现的时候重新刷新数据
- (void)viewWillAppear:(BOOL)animated{
    
    [_tableView reloadData];
    
}

- (void)creatTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_tableView];
    [_tableView registerClass:[MoreTableViewCell class] forCellReuseIdentifier:moreCellId];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if (section == 0) {
        return 2;
    }
    return 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:moreCellId forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            cell.themeImageView.imageName = @"more_icon_theme.png";
            cell.themeTextLabel.text = @"主题选择";
            cell.themeDetailLabel.text = [ThemeManager shareInstance].themeName;
        }
        else if (indexPath.row == 1){
            cell.themeImageView.imageName = @"more_icon_account.png";
            cell.themeTextLabel.text = @"账户管理";
            
        }
    }
    else if (indexPath.section == 1){
        cell.themeTextLabel.text = @"意见反馈";
        cell.themeImageView.imageName = @"more_icon_feedback.png";
    }
    else if (indexPath.section == 2){
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        if ([appDelegate.sinaWeibo isLoggedIn]) {
            cell.themeTextLabel.text = @"退出当前账号";
        } else {
            cell.themeTextLabel.text = @"登入账号";
        }
        cell.themeTextLabel.textAlignment = NSTextAlignmentCenter;
        cell.themeTextLabel.center = cell.contentView.center;
    }
    //设置箭头
    if (indexPath.section != 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //进入主题选择页面
    if (indexPath.row == 0 && indexPath.section == 0) {
        MoreTableViewController *vc = [[MoreTableViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    //登入 登出
    if (indexPath.section == 2 && indexPath.row == 0) {
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        if ([appDelegate.sinaWeibo isLoggedIn]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认退出么?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            
            [alert show];
        } else
        {
            [self logInAction];

        }
    }

}

- (void)logInAction {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.sinaWeibo logIn];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        [appDelegate.sinaWeibo logOut];
    }
    
}


@end
