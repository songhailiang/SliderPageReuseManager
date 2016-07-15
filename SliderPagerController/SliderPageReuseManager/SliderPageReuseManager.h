//
//  SliderPageCache.h
//  SliderPagerController
//
//  Created by 宋海梁 on 16/7/12.
//  Copyright © 2016年 宋海梁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+Reuse.h"

@interface SliderPageReuseManager : NSObject

//缓存最大容量
@property (nonatomic, assign) NSInteger capacity;

- (void)registerViewController:(Class)viewControllerClass forReuseIdentifier:(NSString *)identifier;

- (__kindof UIViewController *)dequeueReuseableViewControllerWithIdentifier:(NSString *)identifier forKey:(NSString *)key;

@end
