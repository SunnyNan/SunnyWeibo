//
//  MoreTableViewCell.m
//  SunnyWeiBo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "MoreTableViewCell.h"

@implementation MoreTableViewCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubView];
        [self colorChangeAction];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorChangeAction) name:kThemeDidChangeNotificationName object:nil];
    }
    return self;
}

- (void)creatSubView {
    
    _themeImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(7, 7, 30, 30)];
    _themeTextLabel = [[ThemeLabel alloc] initWithFrame:CGRectMake(35, 11, 200, 20)];
    _themeDetailLabel = [[ThemeLabel alloc] initWithFrame:CGRectMake(20, 11, 300, 20)];
    _themeTextLabel.font = [UIFont boldSystemFontOfSize:16];
    _themeTextLabel.backgroundColor = [UIColor clearColor];
    _themeTextLabel.colorName = @"More_Item_Text_color";
    
    _themeDetailLabel.font = [UIFont boldSystemFontOfSize:15];
    _themeDetailLabel.backgroundColor = [UIColor clearColor];
    _themeDetailLabel.colorName = @"More_Item_Text_color";
    _themeDetailLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:_themeImageView];
    [self.contentView addSubview:_themeTextLabel];
    [self.contentView addSubview:_themeDetailLabel];
    
}

- (void)colorChangeAction {
    
    self.backgroundColor = [[ThemeManager shareInstance] getThemeColor:@"More_Item_color"];
    
}
@end
