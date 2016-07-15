//
//  UIViewController+ReuseKey.m
//  SliderPagerController
//
//  Created by 宋海梁 on 16/7/14.
//  Copyright © 2016年 宋海梁. All rights reserved.
//

#import "UIViewController+Reuse.h"
#import <objc/runtime.h>

static char reuseKeyKey;
static char isReusedKey;

@implementation UIViewController (Reuse)

- (NSString *)reuseKey {

    return objc_getAssociatedObject(self, &reuseKeyKey);
}

- (void)setReuseKey:(NSString *)reuseKey {

    objc_setAssociatedObject(self, &reuseKeyKey, reuseKey, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)isReused {

    NSNumber *v = objc_getAssociatedObject(self, &isReusedKey);
    return [v boolValue];
}

- (void)setIsReused:(BOOL)isReused {

    objc_setAssociatedObject(self, &isReusedKey, @(isReused), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (instancetype)reuseInstance {

    return [[self alloc] init];
}

- (void)prepareForReuse {

    NSLog(@"ViewController将要被复用");
}

@end
