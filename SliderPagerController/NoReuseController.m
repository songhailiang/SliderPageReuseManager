//
//  NoReuseController.m
//  SliderPagerController
//
//  Created by 宋海梁 on 16/8/2.
//  Copyright © 2016年 宋海梁. All rights reserved.
//

#import "NoReuseController.h"
#import "CategoryController.h"
#import "PhotoController.h"
#import <HMSegmentedControl.h>
#import <Masonry.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface NoReuseController ()<UIScrollViewDelegate>

@property (nonatomic, strong) HMSegmentedControl *titleSegment;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) CategoryController *controller1;
@property (nonatomic, strong) PhotoController *controller2;

@end

@implementation NoReuseController

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
    
    self.titles = @[@"List",@"Grid"];
    [self setupSegment];
    
    [self setupScrollView];
    
    [self setupChildController];
}

//
- (void)setupSegment {
    
    _titleSegment = [[HMSegmentedControl alloc] init];
    _titleSegment.sectionTitles = self.titles;
    _titleSegment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _titleSegment.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _titleSegment.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
//    _titleSegment.segmentEdgeInset = UIEdgeInsetsMake(0, 15, 0, 15);
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

- (void)setupChildController {

    _controller1 = [[CategoryController alloc] init];
    [self addChildViewController:_controller1];
    [_scrollView addSubview:_controller1.view];
    
    [_controller1.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
        make.height.equalTo(_scrollView);
    }];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _controller2 = [sb instantiateViewControllerWithIdentifier:@"PhotoController"];
    
    [self addChildViewController:_controller2];
    [_scrollView addSubview:_controller2.view];
    [_controller2.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.equalTo(_scrollView);
        make.left.equalTo(_controller1.view.mas_right);
        make.width.equalTo(_controller1.view);
    }];
    
}

- (void)sliderToViewAtIndex:(NSInteger)index {
    NSLog(@"slider to %@",@(index));
    
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
