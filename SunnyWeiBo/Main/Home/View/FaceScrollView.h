//
//  FaceScrollView.h
//  SunnyWeiBo
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceView.h"
@interface FaceScrollView : UIScrollView<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    FaceView *_faceView;

}
- (void)setFaceViewDelegate:(id<FaceViewDelegate>)delegate;

@end
