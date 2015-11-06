//
//  ThemeImageView.m
//  SunnyWeiBo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManager.h"
@implementation ThemeImageView
//移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //注册通知观察者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeDidChangeNotificationName object:nil];
    }
    return self;
}
//封装loadImage方法
- (void)loadImage {
    ThemeManager *manage = [ThemeManager shareInstance];
    UIImage *image = [manage getThemeImage:self.imageName];
    UIImage *tempImage = [image stretchableImageWithLeftCapWidth:_leftCapWidth topCapHeight:_topCapHight];
    
    if (image != nil) {
        self.image = tempImage;
    }

}
//图片的名字切换的时候重新向主题管家获取图片方法
- (void)setImageName:(NSString *)imageName {
    if (![_imageName isEqualToString:imageName]) {
        _imageName = [imageName copy];
        [self loadImage];
    }
}
//接到通知实现方法
- (void)themeDidChange:(NSNotification *)notification {
    
    [self loadImage];
}

@end
