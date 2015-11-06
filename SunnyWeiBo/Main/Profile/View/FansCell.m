//
//  FansCell.m
//  SunnyWeiBo
//
//  Created by mac on 15/10/23.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "FansCell.h"

@implementation FansCell

- (void)awakeFromNib {

    
}

- (void)setWeiboModel:(WeiboModel *)weiboModel {
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
