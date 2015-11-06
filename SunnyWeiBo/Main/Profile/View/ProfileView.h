//
//  ProfileView.h
//  SunnyWeiBo
//
//  Created by mac on 15/10/22.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboViewFrameLaout.h"
#import "WeiboModel.h"
@interface ProfileView : UIView
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *nikNameLabel;
//性别
@property (weak, nonatomic) IBOutlet UILabel *gardenLabel;
//省
@property (weak, nonatomic) IBOutlet UILabel *proviceLabel;
//简介
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
//微博数量
@property (weak, nonatomic) IBOutlet UILabel *numbersLabel;
//关注
@property (weak, nonatomic) IBOutlet UILabel *concernLabel;
//粉丝
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;

@property (nonatomic,strong) NSArray *data;

@property (nonatomic,strong) WeiboViewFrameLaout *layout;

@property (nonatomic,strong) WeiboModel *weiboModel;

@end
