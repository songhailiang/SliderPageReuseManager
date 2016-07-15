//
//  ViewController.m
//  SliderPagerController
//
//  Created by 宋海梁 on 16/7/12.
//  Copyright © 2016年 宋海梁. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *controllers;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"SliderPageReuseManager";
    
    self.titles = @[@"复用单一ViewController",
                    @"复用多个ViewController",
                    @"复用UITableView"];
    self.controllers = @[@"ReuseSingleControllerDemo",
                         @"ReuseMultiControllerDemo",
                         @"ReuseTableViewDemo"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.titles objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Class cls = NSClassFromString([self.controllers objectAtIndex:indexPath.row]);
    
    UIViewController *controller = [[cls alloc] init];
    controller.title = [self.titles objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
