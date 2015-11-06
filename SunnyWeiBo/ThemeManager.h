//
//  ThemeManager.h
//  SunnyWeiBo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kThemeDidChangeNotificationName  @"kThemeDidChangeNotificationName"
#define kThemeName @"kThemeName"

@interface ThemeManager : NSObject

@property (nonatomic,copy) NSString *themeName;//主题名字
@property (nonatomic,strong)NSDictionary *themeConfig;//theme.plist的内容
@property (nonatomic,strong)NSDictionary *colorConfig;//每个主题目录下 config.plist内容（颜色值）


+ (ThemeManager *)shareInstance;//单例方法

- (UIImage *)getThemeImage:(NSString *)imageName;//图片名

- (UIColor *)getThemeColor:(NSString *)colorName;//颜色名

@end
