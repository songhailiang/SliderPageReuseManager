//
//  UITableView+Reuse.h
//  SliderPagerController
//
//  Created by 宋海梁 on 16/7/15.
//  Copyright © 2016年 宋海梁. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Reuse)

//指定UITableView的复用Key，根据Key可以获取复用池子里是否已经有此UITableView，如果有则直接取出来使用
@property (nonatomic, copy) NSString *reuseKey;

//指定UITableView是否是被复用的，被复用的UITableView可能需要进行其他处理，比如重新加载新数据等
@property (nonatomic, assign) BOOL isReused;

@end
