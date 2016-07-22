//
//  HorizonTableViewSection.h
//  TestApplicationDelegate
//
//  Created by ZhangShan on 16/7/18.
//  Copyright © 2016年 ZhangShan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HorizonTableViewSection : NSObject

- (CGFloat)sectionWidth;

- (void)setNumberOfColumns:(NSInteger)columns withWidths:(CGFloat *)newColumnWidth;

@property (nonatomic, assign) CGFloat columnWidths;
@property (nonatomic, assign) CGFloat headerWidth;
@property (nonatomic, assign) CGFloat footerWidth;
@property (nonatomic, readonly) NSInteger numberOfColumns;
@property (nonatomic, readonly) CGFloat *columnsWidth;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, copy) NSString *footerTitle;

@end
