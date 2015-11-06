//
//  ProfileView.m
//  SunnyWeiBo
//
//  Created by mac on 15/10/22.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ProfileView.h"
#import "UIImageView+WebCache.h"
#import "ConcernViewController.h"
#import "FansViewController.h"
#import "WeiboTable.h"
#import "ProfileViewController.h"

@implementation ProfileView {

}

- (void)setWeiboModel:(WeiboModel *)weiboModel {
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
        
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headImageView.layer.borderWidth = 1;
    _headImageView.layer.cornerRadius = _headImageView.width/2;
    _headImageView.layer.masksToBounds = YES;
    
    //1.用户头像
    NSString *imgURL = _weiboModel.userModel.avatar_large;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:imgURL]];
    _nikNameLabel.text = _weiboModel.userModel.screen_name;
    _gardenLabel.text = _weiboModel.userModel.gender;
    _proviceLabel.text = _weiboModel.userModel.location;
    _synopsisLabel.text = _weiboModel.userModel.description;
    _numbersLabel.text = [NSString stringWithFormat:@"共%@条微博",_weiboModel.userModel.statuses_count];
    _concernLabel.text = [NSString stringWithFormat:@"%@",_weiboModel.userModel.friends_count];
    _fansLabel.text = [NSString stringWithFormat:@"%@",_weiboModel.userModel.followers_count];

}
@end
