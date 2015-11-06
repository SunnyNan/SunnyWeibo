//
//  ThemeButton.m
//  SunnyWeiBo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"
@implementation ThemeButton

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeDidChangeNotificationName object:nil];
    }
    return self;
}
//封装loadImage方法
- (void)loadImage {
    ThemeManager *manage = [ThemeManager shareInstance];
    UIImage *normalImage = [manage getThemeImage:self.normalImageName];
    UIImage *hightLightImage = [manage getThemeImage:self.highLightedImageName];
    if (normalImage != nil) {
        [self setImage:normalImage forState:UIControlStateNormal];
    }
    if (hightLightImage != nil) {
        [self setImage:hightLightImage forState:UIControlStateHighlighted];
    }
    
}
- (void)themeDidChange:(NSNotification *)notification {

    [self loadImage];
}

- (void)setNormalImageName:(NSString *)normalImageName {
    if (![_normalImageName isEqualToString:normalImageName]) {
        _normalImageName = [normalImageName copy];
        [self loadImage];
    }
}
- (void)setHighLightedImageName:(NSString *)highLightedImageName {
    if (![_highLightedImageName isEqualToString:highLightedImageName]) {
        _highLightedImageName = [highLightedImageName copy];
        [self loadImage];
    }
}

@end
