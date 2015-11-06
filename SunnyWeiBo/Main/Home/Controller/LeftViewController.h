//
//  LeftViewController.h
//  SunnyWeiBo
//
//  Created by mac on 15/10/10.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LeftViewController : BaseViewController
{
    UITableView *_tableView;
    NSArray *_sectionTitles;
    NSArray *_rowTitles;
}
@end
