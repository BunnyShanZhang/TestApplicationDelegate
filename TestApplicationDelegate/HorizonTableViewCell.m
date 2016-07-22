//
//  HorizonTableViewCell.m
//  TestApplicationDelegate
//
//  Created by ZhangShan on 16/7/15.
//  Copyright © 2016年 ZhangShan. All rights reserved.
//

#import "HorizonTableViewCell.h"

@interface HorizonTableViewCell ()

@end

@implementation HorizonTableViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (nil == _titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:self.frame];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _titleLabel;
}

@end
