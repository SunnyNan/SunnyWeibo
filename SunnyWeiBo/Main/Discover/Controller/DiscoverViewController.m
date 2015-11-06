//
//  DiscoverViewController.m
//  SunnyWeiBo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "DiscoverViewController.h"
#import "NearByViewController.h"
@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

- (IBAction)nearByWeibo:(id)sender {
    
    NearByViewController *vc = [[NearByViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
