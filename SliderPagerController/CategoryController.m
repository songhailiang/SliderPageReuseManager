//
//  CategoryController.m
//  SliderPagerController
//
//  Created by 宋海梁 on 16/7/12.
//  Copyright © 2016年 宋海梁. All rights reserved.
//

#import "CategoryController.h"
#import "DetailController.h"
#import <Masonry.h>
#import <MJRefresh.h>

@interface CategoryController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation CategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.datas = [NSMutableArray array];
    [self setupViewUI];
    
    [self.table.mj_header beginRefreshing];
}

- (void)prepareForReuse {

    //清空原来的数据
    [self.datas removeAllObjects];
    [self.table reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {

    NSLog(@"dealloc:%@",NSStringFromClass([self class]));
}

#pragma mark - UI

- (void)setupViewUI {

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _table = [[UITableView alloc] init];
    _table.delegate = self;
    _table.dataSource = self;
    _table.tableFooterView = [UIView new];
    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    [self.view addSubview:_table];
    
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

#pragma mark - Data

- (void)loadData {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.datas removeAllObjects];
        int count = (arc4random() % 40) + 1;
        for (NSInteger i=0; i<count; i++) {
            [self.datas addObject:@(i)];
        }
        
        [self.table.mj_header endRefreshing];
        [self.table reloadData];
    });
}

- (void)reloadData {

    //这里，比较好的处理方式是：优先加载本地缓存数据，无缓存数据时再请求服务端数据
    [self.table.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"【分类%@】这是第%@行",@(self.categoryId),@(indexPath.row)];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailController *detailVc = [[DetailController alloc] init];
    [self.parentViewController.navigationController pushViewController:detailVc animated:YES];
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
