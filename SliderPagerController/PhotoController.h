//
//  PhotoController.h
//  SliderPagerController
//
//  Created by 宋海梁 on 16/7/15.
//  Copyright © 2016年 宋海梁. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoController : UIViewController

@property (nonatomic, assign) NSInteger categoryId;

//重新加载数据
- (void)reloadData;

@end
