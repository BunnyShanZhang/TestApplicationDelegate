//
//  HorizonTableViewSectionLabel.m
//  TestApplicationDelegate
//
//  Created by ZhangShan on 16/7/19.
//  Copyright © 2016年 ZhangShan. All rights reserved.
//

#import "HorizonTableViewSectionLabel.h"

@implementation HorizonTableViewSectionLabel

+ (HorizonTableViewSectionLabel *)sectionLabelWithTitle:(NSString*)title {
    HorizonTableViewSectionLabel *label = [[HorizonTableViewSectionLabel alloc]init];
    label.text = title;
    return label;
}

@end
