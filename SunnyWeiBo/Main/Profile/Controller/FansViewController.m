//
//  FansViewController.m
//  SunnyWeiBo
//
//  Created by mac on 15/10/23.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "FansViewController.h"
#import "FansCell.h"
@interface FansViewController ()
{
    UICollectionView *_collectionView;
}
@end

@implementation FansViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"粉丝列表";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(20, 10, 10, 10);
    CGFloat itemWidth = (kScreenWidth - 10 * 5) / 3;
    layout.itemSize = CGSizeMake( itemWidth, itemWidth);
    
    
     _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //注册单元格
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"FansCell"];
    
    //UINib *nib = [UINib nibWithNibName:@"FansCell" bundle:[NSBundle mainBundle]];
    //[collection registerNib:nib forCellWithReuseIdentifier:@"FansCell"];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FansCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FansCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
