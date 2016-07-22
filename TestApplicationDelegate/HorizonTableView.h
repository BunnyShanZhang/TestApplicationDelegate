//
//  HorizonTableView.h
//  TestApplicationDelegate
//
//  Created by ZhangShan on 16/7/15.
//  Copyright © 2016年 ZhangShan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizonTableViewCell.h"

@class HorizonTableView;

@protocol HorizonTableViewDataSource <NSObject>

@required
- (NSInteger)horizonTableView:(HorizonTableView*)tableView numberOfColunmsInSection:(NSInteger)section;
- (HorizonTableViewCell*)horizonTableView:(HorizonTableView*)tableView cellAtIndexPath:(NSIndexPath*)indexPath;

@optional
- (NSInteger)numberOfSectionsInHorizonTableView:(HorizonTableView*)tableView;
- (NSString *)horizonTableView:(HorizonTableView *)tableView titleForHeadInSection:(NSInteger)section;
-(NSString *)horizonTableView:(HorizonTableView *)tableView titleForFootInSection:(NSInteger)section;

@end

@protocol HorizonTableViewDelegate <NSObject>

@optional
- (CGFloat)horizonTableView:(HorizonTableView*)tableView widthForColumnAtIndexPath:(NSIndexPath*)indexPath;
- (CGFloat)horizonTableView:(HorizonTableView *)tableView widthForHeaderInSection:(NSInteger)section;
- (CGFloat)horizonTableView:(HorizonTableView *)tableView widthForFooterInSection:(NSInteger)section;
- (UIView *)horizonTableView:(HorizonTableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (UIView *)horizonTableView:(HorizonTableView *)tableView viewForFooterInSection:(NSInteger)section;
@end

@interface HorizonTableView : UIScrollView

@property (nonatomic,weak) id<HorizonTableViewDataSource> dataSource;
@property (nonatomic,weak) id<HorizonTableViewDelegate> horizonDelegate;

@property (nonatomic,strong)UIView *tableHeadView;
@property (nonatomic,strong)UIView *tableFootView;

- (void)reloadData;

- (HorizonTableViewCell*)dequeueReusableCellWithIdentifier:(NSString*)indentifier;

@end
