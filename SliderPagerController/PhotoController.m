//
//  PhotoController.m
//  SliderPagerController
//
//  Created by 宋海梁 on 16/7/15.
//  Copyright © 2016年 宋海梁. All rights reserved.
//

#import "PhotoController.h"
#import "PhotoCell.h"
#import <Masonry.h>
#import <MJRefresh.h>

#import "SliderPageReuseManager.h"

@interface PhotoController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation PhotoController

+ (instancetype)reuseInstance {

    NSLog(@"通过Storyboard实例化ViewController");
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [sb instantiateViewControllerWithIdentifier:@"PhotoController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.datas = [NSMutableArray array];
    [self setupViewUI];
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    NSLog(@"dealloc:%@",NSStringFromClass([self class]));
}

#pragma mark - UI

- (void)prepareForReuse {
    
    //清空原来的数据
    [self.datas removeAllObjects];
    [self.collectionView reloadData];
}

- (void)setupViewUI {

    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"Cell"];
}

#pragma mark - Data

- (void)loadData {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.datas removeAllObjects];
        int count = (arc4random() % 30) + 1;
        for (NSInteger i=0; i<count; i++) {
            [self.datas addObject:@(i)];
        }
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
    });
}

- (void)reloadData {
    
    //这里，比较好的处理方式是：优先加载本地缓存数据，无缓存数据时再请求服务端数据
    
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - CollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:@"manji"];
    
    return cell;
}

#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - CollectionView Layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return  CGSizeMake(100, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
