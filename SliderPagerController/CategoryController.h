//
//  CategoryController.h
//  SliderPagerController
//
//  Created by 宋海梁 on 16/7/12.
//  Copyright © 2016年 宋海梁. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryController : UIViewController

@property (nonatomic, assign) NSInteger categoryId;

//重新加载数据
- (void)reloadData;

@end
