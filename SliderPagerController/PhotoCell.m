//
//  PhotoCell.m
//  SliderPagerController
//
//  Created by 宋海梁 on 16/7/15.
//  Copyright © 2016年 宋海梁. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
    }
    
    return self;
}

- (UIImageView *)imageView {

    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _imageView;
}

@end
