//
//  ThemeManager.m
//  SunnyWeiBo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager
{
    NSDictionary *_themeConfig;//Skins/cat
}

+ (ThemeManager *)shareInstance {
    static ThemeManager *instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _themeName = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeName];
        //设置默认主题名
        if (_themeName.length == 0) {
            _themeName = @"Cat";

        }
        
        NSString *configPath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        _themeConfig = [NSDictionary dictionaryWithContentsOfFile:configPath];
        
        NSString *themePath = [self themePath];
        NSString *filePath = [themePath stringByAppendingPathComponent:@"config.plist"];
        _colorConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];
    }
    return self;
}
- (void)setThemeName:(NSString *)themeName {
    if (![_themeName isEqualToString:themeName]) {
        _themeName = [themeName copy];
        //01.存储主题名字到本地持久化
        [[NSUserDefaults standardUserDefaults] setObject:_themeName forKey:kThemeName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //02.重新读取颜色配置文件
        NSString *themePath = [self themePath];
        NSString *filePath = [themePath stringByAppendingPathComponent:@"config.plist"];
        self.colorConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        //03.主题名字改变时 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotificationName object:nil];
    }
}

- (UIColor *)getThemeColor:(NSString *)colorName{
    
    if (colorName.length == 0) {
        return  nil;
    }
    //获取 配置文件中  rgb值
    NSDictionary *rgbDic = [_colorConfig objectForKey:colorName];
    CGFloat r  = [rgbDic[@"R"] floatValue];
    CGFloat g  = [rgbDic[@"G"] floatValue];
    CGFloat b  = [rgbDic[@"B"] floatValue];
    //设置默认alpha值
    CGFloat alpha = 1;

    if (rgbDic[@"alpha"] != nil) {
        alpha = [rgbDic[@"alpha"] floatValue];
    }
    //通过rgb值创建UIColor对象
    UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];

    return color;
    
}

//封装获取主题包路径方法
- (NSString *)themePath {
    //获取主题包根路径
    NSString *resPath = [[NSBundle mainBundle] resourcePath];
    //获取主题包当前路径
    NSString *pathSufix = [_themeConfig objectForKey:self.themeName];
    //拼接路径
    NSString *path = [resPath stringByAppendingPathComponent:pathSufix];
    return path;
}
- (UIImage *)getThemeImage:(NSString *)imageName {
    //获取主题包路径
    NSString *themePath = [self themePath];
    //拼接路径
    NSString *filePath = [themePath stringByAppendingPathComponent:imageName];
    //获得Image
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    return image;
}

@end
