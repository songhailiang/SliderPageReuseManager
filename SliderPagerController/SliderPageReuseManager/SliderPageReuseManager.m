//
//  SliderPageCache.m
//  SliderPagerController
//
//  Created by 宋海梁 on 16/7/12.
//  Copyright © 2016年 宋海梁. All rights reserved.
//

#import "SliderPageReuseManager.h"

@interface SliderPageReuseManager ()

@property (nonatomic, strong) NSMutableDictionary *reuseClasses;

@property (nonatomic, strong) NSMutableDictionary *reusePool;

@end

@implementation SliderPageReuseManager

- (instancetype)init {

    self = [super init];
    if (self) {
        _capacity = 5;
        _reusePool = [NSMutableDictionary dictionary];
        _reuseClasses = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)registerClass:(Class)someClass forReuseIdentifier:(NSString *)identifier {

    [_reuseClasses setObject:someClass forKey:identifier];
    [_reusePool setObject:[NSMutableArray arrayWithCapacity:_capacity] forKey:identifier];
}

- (UIViewController *)dequeueReuseableViewControllerWithIdentifier:(NSString *)identifier forKey:(NSString *)key {

    Class cls = [self.reuseClasses objectForKey:identifier];
    
    NSAssert1(cls, @"没有找到注册类标识：%@", identifier);
    NSAssert1([cls isSubclassOfClass:[UIViewController class]], @"%@注册类型错误", identifier);
    
    NSMutableArray *pool = [self.reusePool objectForKey:identifier];
    
    __block UIViewController *controller;
    [pool enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([vc.reuseKey isEqualToString:key]) {
            controller = vc;
            *stop = YES;
        }
    }];
    
    //复用队列里没有找到
    if (!controller) {
        
        //复用队列超过最大容量，取第一个做复用
        if (pool.count >= self.capacity) {
            NSLog(@"复用ViewController");
            
            controller = [pool firstObject];
        
            //清除原数据
            [controller prepareForReuse];
            
            controller.reuseKey = key;
            
            controller.isReused = YES;
            
            [pool removeObjectAtIndex:0];
        }
        //没有超过最大容量，实例化一个新的
        else {
            NSLog(@"实例化新ViewController");
            
            controller = [cls reuseInstance];
            controller.reuseKey = key;
            controller.isReused = NO;
        }
        
        [pool addObject:controller];
        
    }else {
        
        NSLog(@"找到原来的ViewController");
        [pool removeObject:controller];
        [pool addObject:controller];
        controller.isReused = NO;
    }
    
    return controller;
}

- (UITableView *)dequeueReuseableTableViewWithIdentifier:(NSString *)identifier forKey:(NSString *)key {

    Class cls = [self.reuseClasses objectForKey:identifier];
    
    NSAssert1(cls, @"没有找到注册类标识：%@", identifier);
    NSAssert1([cls isSubclassOfClass:[UITableView class]], @"%@注册类型错误", identifier);
    
    NSMutableArray *pool = [self.reusePool objectForKey:identifier];
    
    __block UITableView *tableView;
    [pool enumerateObjectsUsingBlock:^(UITableView *t, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([t.reuseKey isEqualToString:key]) {
            tableView = t;
            *stop = YES;
        }
    }];
    
    //复用队列里没有找到
    if (!tableView) {
        
        //复用队列超过最大容量，取第一个做复用
        if (pool.count >= self.capacity) {
            NSLog(@"复用TableView");
            
            tableView = [pool firstObject];
            
            tableView.reuseKey = key;
            
            tableView.isReused = YES;
            
            [pool removeObjectAtIndex:0];
        }
        //没有超过最大容量，实例化一个新的
        else {
            NSLog(@"实例化新TableView");
            
            tableView = [[cls alloc]init];
            tableView.reuseKey = key;
            tableView.isReused = NO;
        }
        
        [pool addObject:tableView];
        
    }else {
        
        NSLog(@"找到原来的TableView");
        [pool removeObject:tableView];
        [pool addObject:tableView];
        tableView.isReused = NO;
    }
    
    return tableView;
}

@end
