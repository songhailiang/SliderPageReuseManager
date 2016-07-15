//
//  MainController.m
//  SliderPagerController
//
//  Created by 宋海梁 on 16/7/12.
//  Copyright © 2016年 宋海梁. All rights reserved.
//

#import "ReuseSingleControllerDemo.h"
#import "CategoryController.h"
#import "SliderPageReuseManager.h"

#import <HMSegmentedControl.h>
#import <Masonry.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ReuseSingleControllerDemo ()<UIScrollViewDelegate>

@property (nonatomic, strong) HMSegmentedControl *titleSegment;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) SliderPageReuseManager *reuseManager;

@end

@implementation ReuseSingleControllerDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViewUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setupViewUI {

    _reuseManager = [[SliderPageReuseManager alloc] init];
    [_reuseManager registerClass:[CategoryController class] forReuseIdentifier:@"category"];
    
    self.titles = @[@"全部",@"舞蹈",@"烹饪",@"模特",@"旅游",@"体育",@"书画",@"其他"];
    [self setupSegment];
    
    [self setupScrollView];
    
    [self sliderToViewAtIndex:0];
}

//
- (void)setupSegment {

    _titleSegment = [[HMSegmentedControl alloc] init];
    _titleSegment.sectionTitles = self.titles;
    _titleSegment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    _titleSegment.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    _titleSegment.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
    _titleSegment.segmentEdgeInset = UIEdgeInsetsMake(0, 15, 0, 15);
    [_titleSegment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}];
    [_titleSegment setSelectedTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    
    [_titleSegment addTarget:self action:@selector(titleSegmentControlChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_titleSegment];
    
    [_titleSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@44);
    }];
}

- (void)setupScrollView {

    _scrollView = [[UIScrollView alloc]init];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.titleSegment.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    _scrollView.contentSize = CGSizeMake(kScreenWidth*self.titles.count, 0);
}

- (void)sliderToViewAtIndex:(NSInteger)index {
    NSLog(@"slider to %@",@(index));
    
    NSInteger categoryId = index;
    
    CategoryController *cateVc = [self.reuseManager dequeueReuseableViewControllerWithIdentifier:@"category" forKey:[NSString stringWithFormat:@"%@",@(categoryId)]];
    
    if (!cateVc.parentViewController) {
        [self addChildViewController:cateVc];
    }
    
    cateVc.categoryId = categoryId;
    //如果是复用的ViewController，则加载新数据
    if (cateVc.isReused) {
        [cateVc reloadData];
    }
    
    [_scrollView layoutIfNeeded];
    cateVc.view.frame = CGRectMake(kScreenWidth*index, 0, kScreenWidth, CGRectGetHeight(_scrollView.frame));
    [_scrollView addSubview:cateVc.view];
    
    if (self.titleSegment.selectedSegmentIndex != index) {
        [self.titleSegment setSelectedSegmentIndex:index animated:YES];
    }
    
    [_scrollView setContentOffset:CGPointMake(kScreenWidth*index, 0)];
}

#pragma mark - HMSegmentedControl

- (void)titleSegmentControlChanged:(HMSegmentedControl *)segmentedControl {

    [self sliderToViewAtIndex:segmentedControl.selectedSegmentIndex];
}

#pragma mark - UIScrollView

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    double dIndex = scrollView.contentOffset.x / kScreenWidth;
    NSInteger index = (NSInteger)(dIndex+0.5);
    if (index == self.titleSegment.selectedSegmentIndex) {
        return;
    }
    [self sliderToViewAtIndex:(index)];
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
