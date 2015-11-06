//
//  WeiboCell.h
//  SunnyWeiBo
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboTable.h"
#import "WeiboModel.h"
#import "WeiboViewFrameLaout.h"
#import "WeiboView.h"
@interface WeiboCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nikNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rePostLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *srLabel;

@property (strong,nonatomic) WeiboView *weiboView;

//@property (nonatomic,strong) WeiboModel *model;

@property (nonatomic,strong) WeiboViewFrameLaout *layout;



@end
