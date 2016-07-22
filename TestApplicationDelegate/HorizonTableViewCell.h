//
//  HorizonTableViewCell.h
//  TestApplicationDelegate
//
//  Created by ZhangShan on 16/7/15.
//  Copyright © 2016年 ZhangShan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorizonTableViewCell : UIView

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,copy)NSString *identifier;
@property (nonatomic,assign) NSUInteger index;

@end
