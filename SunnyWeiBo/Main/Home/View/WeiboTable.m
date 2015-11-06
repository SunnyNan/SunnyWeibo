//
//  WeiboTable.m
//  SunnyWeiBo
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboTable.h"
#import "WeiboCell.h"
#import "WeiboModel.h"
#import "WeiboViewFrameLaout.h"
#import "UIImageView+WebCache.h"
#import "WeiboDetailViewController.h"
#import "UIView+UIViewController.h"
@implementation WeiboTable

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
   
        [self creatTable];
        
    }
    return self;
}

- (void)awakeFromNib {
    [self creatTable];
}
- (void)creatTable {
    
    self.delegate = self;
    self.dataSource = self;
    //注册单元格
    UINib *nib  = [UINib nibWithNibName:@"WeiboCell" bundle:nil];
    [self registerNib:nib forCellReuseIdentifier:@"WeiboCellId"];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiboCellId" forIndexPath:indexPath];
    
    WeiboViewFrameLaout *layout = _dataArray[indexPath.row];
    cell.layout = layout;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiboViewFrameLaout *layout = _dataArray[indexPath.row];
    return layout.frame.size.height + 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeiboDetailViewController *vc = [[WeiboDetailViewController alloc] init];
    WeiboViewFrameLaout *layout = _dataArray[indexPath.row];
//    WeiboModel *model = layout.model;
//    vc.weiboModel = model;
    vc.weiboModel = layout.model;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

@end
