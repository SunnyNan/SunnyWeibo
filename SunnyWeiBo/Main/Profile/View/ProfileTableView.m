//
//  ProfileTableView.m
//  SunnyWeiBo
//
//  Created by mac on 15/10/14.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ProfileTableView.h"
#import "ThemeLabel.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "WeiboCell.h"
#import "UIView+UIViewController.h"
#import "WeiboViewFrameLaout.h"
#import "WeiboDetailViewController.h"
@implementation ProfileTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        //注册单元格
        UINib *nib = [UINib nibWithNibName:@"WeiboCell" bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:@"WeiboCellId"];
        
    }
    return self;
    
}

- (void)setWeiboModel:(WeiboModel *)weiboModel{
    if (_weiboModel != weiboModel) {
        
        _weiboModel = weiboModel;
        //1.创建微博视图的布局对象
        WeiboViewFrameLaout *layoutframe = [[WeiboViewFrameLaout alloc] init];
        //isDetail 需要先赋值
        layoutframe.isDetail = YES;
        layoutframe.model = weiboModel;

    
    }
}
#pragma mark - TableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  _data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeiboCell *cell = (WeiboCell *) [tableView dequeueReusableCellWithIdentifier:@"WeiboCellId" forIndexPath:indexPath];
    
    WeiboViewFrameLaout *layout =  _data[indexPath.row];
    
    cell.layout = layout;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiboViewFrameLaout *layout =  _data[indexPath.row];
    
    return layout.frame.size.height + 80;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiboDetailViewController *vc = [[WeiboDetailViewController alloc] init];
    
    
    WeiboViewFrameLaout *layout = _data[indexPath.row];
    WeiboModel *model = layout.model;
    vc.weiboModel = model;
    //依据 响应者 链原理 找到视图控制器
    [self.viewController.navigationController pushViewController:vc animated:YES];
    
    
}


@end
