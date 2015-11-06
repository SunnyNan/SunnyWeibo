//
//  ZoomImageView.h
//  SunnyWeiBo
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZoomImageView;

@protocol ZoomImageViewDelegate <NSObject>

- (void)imageWillZoomIn:(ZoomImageView *)imageView;
- (void)imageWillZoomOut:(ZoomImageView *)imageView;

@end



@interface ZoomImageView : UIImageView<NSURLConnectionDataDelegate,UIAlertViewDelegate>
{
    UIScrollView *_scrollView;
    UIImageView *_fullImageView;
}

@property (nonatomic,weak) id<ZoomImageViewDelegate>delegate;

@property (nonatomic,copy) NSString *fullImageUrlStr;

//gif处理

@property (nonatomic,assign) BOOL isGif;
@property (nonatomic,strong) UIImageView *iconView;

@end
