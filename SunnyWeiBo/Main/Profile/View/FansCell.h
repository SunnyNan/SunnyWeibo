//
//  FansCell.h
//  SunnyWeiBo
//
//  Created by mac on 15/10/23.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
@interface FansCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nikNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *fansLabel;

@property (nonatomic,strong) WeiboModel *weiboModel;

@end
