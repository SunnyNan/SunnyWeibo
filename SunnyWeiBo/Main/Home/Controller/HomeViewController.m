//
//  HomeViewController.m
//  SunnyWeiBo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "ThemeManager.h"
#import "WeiboModel.h"
#import "WeiboTable.h"
#import "WeiboViewFrameLaout.h"
#import "MJRefresh.h"
#import "ThemeImageView.h"
#import "ThemeLabel.h"
#import <AudioToolbox/AudioToolbox.h>
@interface HomeViewController ()
{
    NSMutableArray *_data;
    WeiboTable *_weiboTable;
    ThemeImageView *_barImageView;//弹出更新的微博提示
    ThemeLabel *_barLabel;//更新的微博数量提示
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self creatTableView];
    [self setNavigationItem];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"获取失败");
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    //NSLog(@"%@",result);
    NSArray *dicArray = [result objectForKey:@"statuses"];
    
    NSMutableArray *modelArray = [[NSMutableArray alloc]initWithCapacity:dicArray.count];
    
    for(NSDictionary *dic in dicArray)
    {
        WeiboModel *model = [[WeiboModel alloc] initWithDataDic:dic];
        
        WeiboViewFrameLaout *layout = [[WeiboViewFrameLaout alloc] init];
        layout.model = model;
        
        [modelArray addObject:layout];
        
    }
    //处理网络数据 进行全局拼接
    //新的微博 插入到 _data前面
    //上拉加载的图片 插入到 _data后面
    
    if (request.tag == 100) {
        _data = modelArray;
        
        [self comleteHud:@"加载完成"];
        
    }else if (request.tag == 101) {
        if (_data == nil) {
            _data = modelArray;
        }else {
        
            NSRange range = NSMakeRange(0, modelArray.count);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [_data insertObjects:modelArray atIndexes:indexSet];
            //弹出提示
            [self showNewsWeiboCount:modelArray.count];
        }
    }else if (request.tag == 102) {
        if (_data == nil) {
            _data = modelArray;
        }else {
            [_data removeLastObject];
            [_data addObjectsFromArray:modelArray];
            
        }
    }
    if (_data.count != 0) {
        _weiboTable.dataArray = _data;
        [_weiboTable reloadData];
        
    }
    
    [_weiboTable.header endRefreshing];
    [_weiboTable.footer endRefreshing];
}

- (void)creatTableView {

    _weiboTable = [[WeiboTable alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    
    [self.view addSubview:_weiboTable];
    _weiboTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _weiboTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
    
}

#pragma mark -下拉刷新
- (void)loadNewData {
    AppDelegate *appDelegate =  (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (appDelegate.sinaWeibo.isLoggedIn) {
        //params处理
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        //设置刷新的数据条数
        [params setObject:@"10" forKey:@"count"];

        if (_data.count != 0) {
            WeiboViewFrameLaout *layoutFrame = [_data lastObject];
            WeiboModel *model = layoutFrame.model;
            NSString *maxId = model.weiboIdStr;
            [params setObject:maxId forKey:@"max_id"];

        }
        SinaWeiboRequest *request = [appDelegate.sinaWeibo requestWithURL:@"statuses/home_timeline.json"
                                                                   params:params httpMethod:@"GET" delegate:self];
        request.tag = 101;
        
        return;
    }
    [appDelegate.sinaWeibo logIn];

}
#pragma mark - 上拉加载
- (void)loadOldData {
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
        
        
        
        SinaWeiboRequest *request = [appDelegate.sinaWeibo requestWithURL:@"statuses/home_timeline.json"
                                                                   params:params
                                                               httpMethod:@"GET"
                                                                 delegate:self];
        
        request.tag = 102;
        
        return;
    }
    [appDelegate.sinaWeibo logIn];

    
}
#pragma mark - 微博数据请求
- (void)loadData{
    
    //测试 获取微博
    
    [self showHud:@"正在加载..."];
    
    AppDelegate *appDelegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"10" forKey:@"count"];
    
    SinaWeiboRequest * request =     [sinaWeibo requestWithURL:@"statuses/home_timeline.json"
                                                        params:params
                                                    httpMethod:@"GET"
                                                      delegate:self];
    
    request.tag = 100;


}

- (void)showNewsWeiboCount:(NSInteger)count {
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
            _barImageView.transform = CGAffineTransformMakeTranslation(0, 64 + 5 + 40);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.6 animations:^{
                //提示消息停留一秒
                [UIView setAnimationDelay:1];
                _barImageView.transform = CGAffineTransformIdentity;
                
//            } completion:^(BOOL finished) {
                
            }];
        }];
     
        //播放声音
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:path];
        
        //注册系统声音
        SystemSoundID soundId;// 0
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundId);
        AudioServicesPlaySystemSound(soundId);
        

    }
}


@end
