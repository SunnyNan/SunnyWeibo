//
//  ZoomImageView.m
//  SunnyWeiBo
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ZoomImageView.h"
#import "MBProgressHUD.h"
#import "UIImage+GIF.h"
#import <ImageIO/ImageIO.h>

@implementation ZoomImageView
{
    NSURLConnection *_connection;
    double _length;
    NSMutableData *_data;
    MBProgressHUD *_hud;

}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initTap];
        
        [self createIconView];
    }
    return self;
}


- (void)initTap {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomIn)];
    [self addGestureRecognizer:tap];
    
    self.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)zoomIn {
    
    if ([self.delegate respondsToSelector:@selector(imageWillZoomIn:)]) {
        [self.delegate imageWillZoomIn:self];
    }
    //01 创建缩放视图
    [self createViews];
    //02 把相对于cell的frame转换成相对于window的frame
    //self.frame --> cell
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    _fullImageView.frame = frame;
    //03 动画
    self.hidden = YES;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        _fullImageView.frame = _scrollView.frame;
    } completion:^(BOOL finished) {
        _scrollView.backgroundColor = [UIColor blackColor];
        //下载图片
        [self downLoadImage];
        
    }];

}


- (void)createIconView {
    _iconView = [[UIImageView alloc] init];
    _iconView.image = [UIImage imageNamed:@"timeline_gif.png"];
    [self addSubview:_iconView];
    _iconView.hidden = YES;
}

- (void)createViews {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.window addSubview:_scrollView];
        
        _fullImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        _fullImageView.image = self.image;
        [_scrollView addSubview:_fullImageView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOut)];
        [_scrollView addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(savePhoto:)];
        [_scrollView addGestureRecognizer:longPress];
    }
}

- (void)savePhoto:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        NSLog(@"保存图片");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否保存图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UIImage *image = _fullImageView.image;
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"保存成功");
    //提示保存成功
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    //显示模式改为：自定义视图模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"保存成功";
    
    //延迟隐藏
    [hud hide:YES afterDelay:1.5];

}

- (void)zoomOut {
    
    if ([self.delegate respondsToSelector:@selector(imageWillZoomOut:)]) {
        [self.delegate imageWillZoomOut:self];
    }
    _scrollView.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:2 animations:^{
        CGRect frame = [self convertRect:self.bounds toView:self.window];
        
        _fullImageView.frame = frame;
        
        //如果scroll内容偏移,偏移量也要考虑进去
        _fullImageView.top += _scrollView.contentOffset.y;
        
    } completion:^(BOOL finished) {
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        _fullImageView = nil;
        self.hidden = NO;
        
    }];
}

- (void)downLoadImage{
    if (_fullImageUrlStr.length != 0) {
        
        //下载进度显示
        _hud = [MBProgressHUD showHUDAddedTo:_scrollView animated:YES];
        _hud.mode = MBProgressHUDModeDeterminate;
        _hud.progress = 0.0;
        
        NSURL *url = [NSURL URLWithString:_fullImageUrlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
        
        _connection =  [NSURLConnection connectionWithRequest:request delegate:self];
        
        
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    //01 获取响应头
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    
    NSDictionary *headFields =  [httpResponse allHeaderFields];
    //NSLog(@"%@",headFields);
    
    
    NSString *lengthStr  = [headFields objectForKey:@"Content-Length"];
    
    _length = [lengthStr doubleValue];
    
    _data = [[NSMutableData alloc]init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_data appendData:data];
    CGFloat progress = _data.length/_length;
    _hud.progress = progress;
    //NSLog(@"进度  %f",progress);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    //NSLog(@"下载完毕");
    [_hud hide:YES];
    
    UIImage *image = [UIImage imageWithData:_data];
    
    _fullImageView.image = image;
    
    
    //尺寸处理
    // kScreenWidth/length = image.size.width/image.size.height
    
    CGFloat length = image.size.height/image.size.width * kScreenWidth;
    if (length > kScreenHeight) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _fullImageView.height = length;
            _scrollView.contentSize = CGSizeMake(kScreenWidth, length);
            
        }];
        
    }
    if (_isGif) {
        [self showGif];
    }
    
}

- (void)showGif {
    //01 -------- WebView播放-----
    //    UIWebView *webView = [[UIWebView alloc] initWithFrame:_scrollView.bounds];
    //    webView.userInteractionEnabled = NO;
    //
    //    [webView loadData:_data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    //    [_scrollView addSubview:webView];
    //
    
    //02 三方 sdWebImage
    
    
    _fullImageView.image = [UIImage sd_animatedGIFWithData:_data];
    //03 用 ImageIO
    //创建图片源
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)_data, NULL);
    //得到图片个数
    size_t count = CGImageSourceGetCount(source);
    
    //把所有的图片 解析到 数组中
    NSMutableArray *images = [NSMutableArray array];
    
    NSTimeInterval duration = 0.0f;
    
    for (size_t i = 0; i < count; i++) {
        //获取每一张图片 放到UIImage对象里面
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        
        duration += 0.1;
        
        [images addObject:[UIImage imageWithCGImage:image]];
        
        CGImageRelease(image);
    }
    
    //播放YI
    //    _fullImageView.animationImages = images;
    //    _fullImageView.animationDuration = duration;
    //    [_fullImageView startAnimating];
    //
    //播放二
    
    UIImage *animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    _fullImageView.image = animatedImage;
    
    CFRelease(source);
    
    
    //03 三方
    //[UIImage sd_animatedGIFWithData:_data];

}


@end
