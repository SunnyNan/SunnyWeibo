//
//  ProfileViewController.m
//  SunnyWeiBo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "ThemeManager.h"
#import "WeiboModel.h"
#import "WeiboViewFrameLaout.h"
#import "ThemeLabel.h"
#import "MJRefresh.h"
#import "ThemeImageView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIImageView+WebCache.h"
#import "WeiboTable.h"
#import "ConcernViewController.h"
#import "FansViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

{
    NSMutableArray *_data;
    ThemeImageView *_barImageView;//弹出微博条数提示
    ThemeLabel *_barLabel;//提示文字
    WeiboModel *_model;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    _data = [[NSMutableArray alloc] init];
    
    [self creatTableView];

}

- (void)viewDidAppear:(BOOL)animated{
    [self loadData];

}


- (void)creatTableView {
    //concernButton
    UIButton *conBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 120, 60, 60)];
    conBtn.backgroundColor = [UIColor clearColor];
    conBtn.layer.borderColor = [UIColor greenColor].CGColor;
    conBtn.layer.borderWidth = 1;
    conBtn.layer.cornerRadius = 10;
    [conBtn addTarget:self action:@selector(concernBtn:) forControlEvents:UIControlEventTouchUpInside];

    //fansButton
    UIButton *fansBtn = [[UIButton alloc] initWithFrame:CGRectMake(110, 120, 60, 60)];
    fansBtn.backgroundColor = [UIColor clearColor];
    fansBtn.layer.borderColor = [UIColor greenColor].CGColor;
    fansBtn.layer.borderWidth = 1;
    fansBtn.layer.cornerRadius = 10;
    [fansBtn addTarget:self action:@selector(fansBtn:) forControlEvents:UIControlEventTouchUpInside];
    //moreButton
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 120, 60, 60)];
    moreBtn.backgroundColor = [UIColor clearColor];
    moreBtn.layer.borderColor = [UIColor greenColor].CGColor;
    moreBtn.layer.borderWidth = 1;
    moreBtn.layer.cornerRadius = 10;
    //resourceButton
    UIButton *resourceBtn = [[UIButton alloc] initWithFrame:CGRectMake(290, 120, 60, 60)];
    resourceBtn.backgroundColor = [UIColor clearColor];
    resourceBtn.layer.borderColor = [UIColor greenColor].CGColor;
    resourceBtn.layer.borderWidth = 1;
    resourceBtn.layer.cornerRadius = 10;
 


    //createLabels
    UILabel *concernLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 60, 60)];
    concernLabel.text = @"关注";
    concernLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 60, 60)];
    fansLabel.text = @"粉丝";
    fansLabel.textAlignment = NSTextAlignmentCenter;
   
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    moreLabel.textAlignment = NSTextAlignmentCenter;
    moreLabel.text = @"更多";
    
    UILabel *sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    sourceLabel.text = @"资料";
    sourceLabel.textAlignment = NSTextAlignmentCenter;
    
    //2.加载xib创建用户视图
    _profileView = [[[NSBundle mainBundle] loadNibNamed:@"ProfileView" owner:self options:nil] lastObject];
    _profileView.backgroundColor = [UIColor clearColor];
    _profileView.width = kScreenWidth;
    _profileView.frame = CGRectMake(0, 0, kScreenWidth, 240);
    _profileView.backgroundColor =  [UIColor colorWithWhite:0.5 alpha:0.1];
    [self.view addSubview:_profileView];
    [_profileView addSubview:conBtn];
    [conBtn addSubview:concernLabel];
    [_profileView addSubview:fansBtn];
    [fansBtn addSubview:fansLabel];
    [_profileView addSubview:resourceBtn];
    [resourceBtn addSubview:sourceLabel];
    [_profileView addSubview:moreBtn];
    [moreBtn addSubview:moreLabel];
    _weiboTable = [[ProfileTableView alloc]
                   initWithFrame:CGRectMake(0, 240, kScreenWidth, kScreenHeight)];
    _weiboTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_weiboTable];
    
    _weiboTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _weiboTable.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    

    
}

- (void)concernBtn:(UIButton *)button {
    ConcernViewController *concernVc = [[ConcernViewController alloc] init];
    [self.navigationController pushViewController:concernVc animated:YES];
}

- (void)fansBtn:(UIButton *)button {
    FansViewController *fansVc = [[FansViewController alloc] init];
    [self.navigationController pushViewController:fansVc animated:YES];
}
#pragma mark - 刷新新的微博
- (void)loadNewData {
    
    AppDelegate *appDelegate =  (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (appDelegate.sinaWeibo.isLoggedIn) {
        //params处理
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"10" forKey:@"count"];
        //设置 sinceId
        if (_data.count != 0) {
            WeiboViewFrameLaout *layoutFrame = _data[0];
            WeiboModel *model = layoutFrame.model;
            NSString *sinceId = model.weiboIdStr;
            [params setObject:sinceId forKey:@"since_id"];
        }
        
        
        SinaWeiboRequest *request = [appDelegate.sinaWeibo requestWithURL:@"statuses/user_timeline.json"
                                                                   params:params
                                                               httpMethod:@"GET"
                                                                 delegate:self];
        request.tag = 102;
        
        
        return;
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请登录" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
}
#pragma mark - 刷新之前的微博
- (void)loadMoreData {
    AppDelegate *appDelegate =  (AppDelegate*)[UIApplication sharedApplication].delegate;
    //如果已经登陆则获取微博数据
    if (appDelegate.sinaWeibo.isLoggedIn) {
        
        //params处理
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"10" forKey:@"count"];
        
        //设置maxId
        if (_data.count != 0) {
            WeiboViewFrameLaout *layoutFrame = [_data lastObject];
            WeiboModel *model = layoutFrame.model;
            NSString *maxId = model.weiboIdStr;
            [params setObject:maxId forKey:@"max_id"];
            
        }
        
        SinaWeiboRequest *request = [appDelegate.sinaWeibo requestWithURL:@"statuses/user_timeline.json"
                                                                   params:params
                                                               httpMethod:@"GET"
                                                                 delegate:self];
        
        request.tag = 101;
        
        
        return;
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请登录" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)loadData {
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if(appdelegate.sinaWeibo.isLoggedIn)
    {
        [self showHud:@"正在加载"];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:@"10" forKey:@"count"];
        SinaWeiboRequest *request = [appdelegate.sinaWeibo requestWithURL:@"statuses/user_timeline.json"
                                                                   params:params
                                                               httpMethod:@"GET"
                                                                 delegate:self];
        request.tag =100;
        return;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请登录" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    //每一条微博存到 数组里
    NSArray *dicArray = [result objectForKey:@"statuses"];
    
    NSMutableArray *layoutFrameArray = [[NSMutableArray alloc] initWithCapacity:dicArray.count];
    
    //解析model,然后把model存放到dataArray,然后再把dataArray 交给weiboTable;
    
    for (NSDictionary *dataDic in dicArray) {
        _model = [[WeiboModel alloc] initWithDataDic:dataDic];
        WeiboViewFrameLaout *layoutFrame = [[WeiboViewFrameLaout alloc] init];
        layoutFrame.model = _model;
        
        [layoutFrameArray addObject:layoutFrame];
    }
    
    if (request.tag == 100) {//普通加载微博
        //[self showLoading:NO];
        
        //[self hideHUD];
        

        [self comleteHud:@"加载完成"];
        _data = layoutFrameArray;
        
    }else if(request.tag == 101){//更多微博
        
        if (layoutFrameArray.count > 1) {
            [layoutFrameArray removeObjectAtIndex:0];
            [_data addObjectsFromArray:layoutFrameArray];
        }
        
        
    }else if(request.tag == 102){//最新微博
        if (layoutFrameArray.count > 0) {
            
            NSRange range = NSMakeRange(0, layoutFrameArray.count);
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            
            [_data insertObjects:layoutFrameArray atIndexes:indexSet];
            
            [self showNewWeiboCount:layoutFrameArray.count];
            
        }
        
    }
    
    if (_data.count != 0) {
        _weiboTable.data = _data;
        _profileView.data = _data;
        _profileView.weiboModel = _model;
        [_weiboTable reloadData];
    }
    
    
    [_weiboTable.header endRefreshing];
    [_weiboTable.footer endRefreshing];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showNewWeiboCount:(NSInteger)count{
    if (_barImageView == nil) {
        
        _barImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(5, -40, kScreenWidth-10, 40)];
        _barImageView.imageName = @"timeline_notify.png";
        [self.view addSubview:_barImageView];
        
        
        _barLabel = [[ThemeLabel alloc] initWithFrame:_barImageView.bounds];
        _barLabel.colorName = @"Timeline_Notice_color";
        _barLabel.backgroundColor = [UIColor clearColor];
        _barLabel.textAlignment = NSTextAlignmentCenter;
        
        [_barImageView addSubview:_barLabel];
        
    }
    
    if (count > 0) {
        _barLabel.text = [NSString stringWithFormat:@"更新了%li条微博",count];
        
        
        [UIView animateWithDuration:0.6 animations:^{
            _barImageView.transform = CGAffineTransformMakeTranslation(0, 64+5+40);
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.6 animations:^{
                [UIView setAnimationDelay:1];//让提示消息停留一秒
                _barImageView.transform = CGAffineTransformIdentity;
            }];
            
        }];
        
    }
    
    
    
}


@end
