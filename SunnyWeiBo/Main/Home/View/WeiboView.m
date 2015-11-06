//
//  WeiboView.m
//  SunnyWeiBo
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboView.h"
#import "UIImageView+WebCache.h"
#import "ThemeManager.h"
@implementation WeiboView

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        [self createSubView];
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView];
    }
    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)createSubView {
    
    //微博内容
    _textLabel = [[WXLabel alloc] init];
    _textLabel.wxLabelDelegate = self;
    _textLabel.linespace = 5;
    _textLabel.font = [UIFont systemFontOfSize:15];
    _textLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
    //原微博内容
    _sourceLabel = [[WXLabel alloc] init];
    _sourceLabel.wxLabelDelegate =self;
    _sourceLabel.linespace = 5;
    _sourceLabel.font = [UIFont systemFontOfSize:14];
    _sourceLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
    
    //微博图片
    _imgView = [[ZoomImageView alloc] init];
    //背景图片
    _bgImageView = [[ThemeImageView alloc] init];
    _bgImageView.topCapHight = 30;
    _bgImageView.leftCapWidth = 30;
    _bgImageView.imageName = @"timeline_rt_border_9.png";
    
    [self addSubview:_bgImageView];
    [self addSubview:_textLabel];
    [self addSubview:_sourceLabel];
    [self addSubview:_imgView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeDidChangeNotificationName object:nil];
    
}

- (void)themeDidChange:(NSNotification *)notification {
    
    _textLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
    _sourceLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
    
}
- (void)setLayout:(WeiboViewFrameLaout *)layout {
    if (_layout != layout) {
        _layout = layout;
        [self setNeedsLayout];
    }
    
}
- (void)layoutSubviews {
    //[self layoutSubviews];
    //设置字体
    _textLabel.font = [UIFont systemFontOfSize:FontSize_Weibo(_layout.isDetail)];
    _sourceLabel.font = [UIFont systemFontOfSize:FontSize_ReWeibo(_layout.isDetail)];
    WeiboModel *model = _layout.model;
    
    //微博文字
    _textLabel.frame = _layout.textFrame;
    _textLabel.text = model.text;
    
    //转发
    if (model.reWeiboModel != nil) {
        _bgImageView.hidden = NO;
        _sourceLabel.hidden = NO;
        
        //被转发的微博
        _sourceLabel.frame = _layout.srTextFrame;
        _sourceLabel.text = model.reWeiboModel.text;
        //背景图片
        _bgImageView.frame = _layout.bgImageFrame;
        _bgImageView.imageName = @"timeline_rt_border_9.png";
        
        
        //图片
        NSString *imageStr = model.reWeiboModel.thumbnailImage;
        if (imageStr == nil) {
            _imgView.hidden = YES;
        }else{
            
            //下载清晰图片
            _imgView.fullImageUrlStr = model.reWeiboModel.originalImage;
            _imgView.hidden = NO;
            
            _imgView.frame = _layout.imgFrame;
            [_imgView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
        }


    }else {
        //没转发
        _bgImageView.hidden = YES;
        _sourceLabel.hidden = YES;
        
        //图片
        NSString *imageStr = model.thumbnailImage;
        if (imageStr == nil) {
            _imgView.hidden = YES;
        }else{
            _imgView.hidden = NO;
            _imgView.frame = _layout.imgFrame;
            [_imgView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
        }
    }
    
    if (_imgView.hidden == NO) {
        _imgView.iconView.frame = CGRectMake(_imgView.width - 24, _imgView.height - 24, 24, 24);
        NSString *extersion;
        if (model.reWeiboModel == nil) {
            extersion = [model.reWeiboModel.thumbnailImage pathExtension];
        }else {
            extersion = [model.thumbnailImage pathExtension];
        }
        if ([extersion isEqualToString:@"gif"]) {
            _imgView.isGif = YES;
            _imgView.iconView.hidden = NO;
            
        }else {
            _imgView.isGif = NO;
            _imgView.iconView.hidden = YES;
        }
        
    }
}

#pragma mark - WXLabelDelegate
//正则表达式
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel
{
    //需要添加链接字符串的正则表达式：@用户、http://、#话题#
    NSString *regex1 = @"@\\w+";
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"#\\w+#";
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    return regex;
}

//手指接触当前超链接文本响应的协议方法
- (void)toucheBenginWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context {
    NSLog(@"点击");
}

//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel {
    return [[ThemeManager shareInstance] getThemeColor:@"Link_color"];
}
//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel {
    return [UIColor redColor];
}


@end
