//
//  WeiboAnnotationView.h
//  SunnyWeiBo
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface WeiboAnnotationView : MKAnnotationView{
    UIImageView *_headImageView;//UserHeaderImage
    UILabel *_textLabel;//WeiboText
}
@end
