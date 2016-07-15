//
//  ReuseTableViewDemo.m
//  SliderPagerController
//
//  Created by 宋海梁 on 16/7/15.
//  Copyright © 2016年 宋海梁. All rights reserved.
//

#import "ReuseTableViewDemo.h"
#import "SliderPageReuseManager.h"

#import <HMSegmentedControl.h>
#import <Masonry.h>
#import <MJRefresh.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ReuseTableViewDemo ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) HMSegmentedControl *titleSegment;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) SliderPageReuseManager *reuseManager;

@property (nonatomic, assign) NSInteger currentCategoryId;
@property (nonatomic, strong) UITableView *reuseTable;
@property (nonatomic, strong) NSMutableDictionary *datas;

@end

@implementation ReuseTableViewDemo

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
    
    self.datas = [NSMutableDictionary dictionary];
    _reuseManager = [[SliderPageReuseManager alloc] init];
    [_reuseManager registerClass:[UITableView class] forReuseIdentifier:@"table"];
    
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
    
    self.reuseTable = [self.reuseManager dequeueReuseableTableViewWithIdentifier:@"table" forKey:[NSString stringWithFormat:@"%@",@(categoryId)]];
    
    self.currentCategoryId = categoryId;
    
    //如果是复用的tableView，则加载新数据
    if (self.reuseTable.isReused) {
        
        [self.reuseTable reloadData];
        
        [self reloadData];
    }
    else {
        
        //new tableview
        if (!self.reuseTable.superview) {
            
            self.reuseTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
            
            [self.reuseTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
            self.reuseTable.dataSource = self;
            self.reuseTable.delegate = self;
            
            [self.reuseTable.mj_header beginRefreshing];
        }
        else {
            [self.reuseTable reloadData];
        }
    }
    
    [_scrollView layoutIfNeeded];
    self.reuseTable.frame = CGRectMake(kScreenWidth*index, 0, kScreenWidth, CGRectGetHeight(_scrollView.frame));
    [_scrollView addSubview:self.reuseTable];
    
    if (self.titleSegment.selectedSegmentIndex != index) {
        [self.titleSegment setSelectedSegmentIndex:index animated:YES];
    }
    
    [_scrollView setContentOffset:CGPointMake(kScreenWidth*index, 0)];
}

#pragma mark - Data

- (void)loadData {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSMutableArray *arr = [self.datas objectForKey:@(self.currentCategoryId)];
        if (!arr) {
            arr = [NSMutableArray array];
        }
        [arr removeAllObjects];
        int count = (arc4random() % 40) + 1;
        for (NSInteger i=0; i<count; i++) {
            [arr addObject:@(i)];
        }
        [self.datas setObject:arr forKey:@(self.currentCategoryId)];
        
        [self.reuseTable.mj_header endRefreshing];
        [self.reuseTable reloadData];
    });
}

- (void)reloadData {
    
    //这里，比较好的处理方式是：优先加载本地缓存数据，无缓存数据时再请求服务端数据
    [self.reuseTable.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSMutableArray *arr = [self.datas objectForKey:@(self.currentCategoryId)];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"【分类%@】这是第%@行",@(self.currentCategoryId),@(indexPath.row)];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *arr = [self.datas objectForKey:@(self.currentCategoryId)];
    
    NSLog(@"点击了：分类【%@】，data=【%@】",@(self.currentCategoryId),[arr objectAtIndex:indexPath.row]);
}

#pragma mark - HMSegmentedControl

- (void)titleSegmentControlChanged:(HMSegmentedControl *)segmentedControl {
    
    [self sliderToViewAtIndex:segmentedControl.selectedSegmentIndex];
}

#pragma mark - UIScrollView

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView != self.scrollView) {
        return;
    }
    double dIndex = scrollView.contentOffset.x / kScreenWidth;
    NSInteger index = (NSInteger)(dIndex+0.5);
    if (index == self.titleSegment.selectedSegmentIndex) {
        return;
    }
    [self sliderToViewAtIndex:(index)];
}


@end
