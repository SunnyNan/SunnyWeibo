//
//  SendViewController.h
//  SunnyWeiBo
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseViewController.h"
#import "ZoomImageView.h"
#import <CoreLocation/CoreLocation.h>
#import "FaceScrollView.h"
@interface SendViewController : BaseViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,ZoomImageViewDelegate,CLLocationManagerDelegate,FaceViewDelegate>
{
    UITextView *_textView;
    UIView *_editorBar;
    ZoomImageView *_zoomImageView;
    CLLocationManager *_locationManager;
    UILabel *_locationLabel;
    //5 表情面板
    FaceScrollView *_faceViewPanel;

}
@end
