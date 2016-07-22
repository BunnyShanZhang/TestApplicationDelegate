//
//  HorizonTableViewSection.m
//  TestApplicationDelegate
//
//  Created by ZhangShan on 16/7/18.
//  Copyright © 2016年 ZhangShan. All rights reserved.
//

#import "HorizonTableViewSection.h"

@implementation HorizonTableViewSection

- (CGFloat)sectionWidth
{
    return self.columnWidths + self.headerWidth + self.footerWidth;
}


- (void)setNumberOfColumns:(NSInteger)columns withWidths:(CGFloat *)newColumnWidth
{
    _columnsWidth = realloc(_columnsWidth, sizeof(CGFloat)*columns);
    memcpy(_columnsWidth, newColumnWidth, sizeof(CGFloat)*columns);
    _numberOfColumns = columns;
}

@end
