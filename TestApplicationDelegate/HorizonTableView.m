//
//  HorizonTableView.m
//  TestApplicationDelegate
//
//  Created by ZhangShan on 16/7/15.
//  Copyright © 2016年 ZhangShan. All rights reserved.
//

#import "HorizonTableView.h"
#import "HorizonTableViewSection.h"
#import "HorizonTableViewSectionLabel.h"

const CGFloat HorizonTableViewDefaultColumnWidth = 43;

@interface HorizonTableView () <UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableDictionary *cacheCells;
@property (nonatomic,strong) NSMutableSet* reuseCell;
@property (nonatomic,strong) NSMutableArray *sections;

@property (nonatomic,assign) BOOL needsReload;

@end

@implementation HorizonTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.cacheCells = [NSMutableDictionary dictionary];
        self.reuseCell = [[NSMutableSet alloc]initWithCapacity:0];
        self.sections = [NSMutableArray array];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        super.delegate = self;
        
        [self setNeedsReload];
    }
    return self;
}

- (void)setNeedsReload {
    _needsReload = YES;
    [self setNeedsLayout];
}

- (void)reloadDataIfNeeded {
    if (_needsReload) {
        [self reloadData];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self reloadDataIfNeeded];
    [self layoutTableViews];
}

- (void)layoutTableViews
{
    CGRect visibleBounds = self.bounds;
    CGFloat tableWidth = 0;
    if (_tableHeadView) {
        CGRect tableHeaderFrame = _tableHeadView.frame;
        tableHeaderFrame.origin = CGPointZero;
        tableHeaderFrame.size.height = self.frame.size.height;
        _tableHeadView.frame = tableHeaderFrame;
        tableWidth += tableHeaderFrame.size.width;
    }
    NSMutableDictionary *availableCells = [self.cacheCells mutableCopy];
    [self.cacheCells removeAllObjects];
    
    for (int i=0; i<self.sections.count; i++) {
        HorizonTableViewSection *sectionModel = self.sections[i];
        if (sectionModel.headerView) {
            sectionModel.headerView.frame = [self rectForHeaderInSection:i];
        }
        if (sectionModel.footerView) {
            sectionModel.footerView.frame = [self rectForFooterInSection:i];
        }
        tableWidth+=sectionModel.sectionWidth;
        CGRect sectionRect = [self rectForSection:i];
        if(CGRectIntersectsRect(sectionRect, visibleBounds)) {
            for(int j=0; j<sectionModel.numberOfColumns; j++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                CGRect cellRect = [self rectForCell:indexPath];
                if (CGRectIntersectsRect(cellRect, visibleBounds)) {
                    HorizonTableViewCell *cell = [availableCells objectForKey:indexPath];
                    if (nil == cell) {
                        cell = [self.dataSource horizonTableView:self cellAtIndexPath:indexPath];
                    }
                    else {
                        [availableCells removeObjectForKey:indexPath];
                    }
                    cell.frame = cellRect;
                    [self.cacheCells setObject:cell forKey:indexPath];
                    [self addSubview:cell];
                }
            }
        }
    }
    
    for (HorizonTableViewCell *cell in [availableCells allValues]) {
        if (cell.identifier.length>0) {
             [self.reuseCell addObject:cell];
        }
        else {
            [cell removeFromSuperview];
        }
    }
    
    NSArray *allValue = [self.cacheCells allValues];
    for (HorizonTableViewCell *cell in [availableCells allValues]) {
        if (CGRectIntersectsRect(cell.frame, visibleBounds) && ![allValue containsObject:cell]) {
            [cell removeFromSuperview];
        }
    }
    
    if (_tableFootView) {
        CGRect tableFooterFrame = _tableFootView.frame;
        tableFooterFrame.origin = CGPointMake(tableWidth, _tableFootView.frame.origin.y);
        tableFooterFrame.size.height = self.frame.size.height;
        _tableFootView.frame = tableFooterFrame;
        tableWidth += tableFooterFrame.size.width;
    }
    
}

- (void)updateSectionCacheIfNeeded
{
    if ([self.sections count] == 0) {
        [self updateSectionCache];
    }
}

- (void)updateSectionCache //更新sections数组
{
    for (HorizonTableViewSection *section in self.sections) {
        if(section.headerView) {
            [section.headerView removeFromSuperview];
        }
        if (section.footerView) {
            [section.footerView removeFromSuperview];
        }
    }
    [self.sections removeAllObjects];
    
    NSInteger sections = 1;
    if (_dataSource) {
        if ([_dataSource conformsToProtocol:@protocol(HorizonTableViewDataSource)] && [_dataSource respondsToSelector:@selector(numberOfSectionsInHorizonTableView:)]) {
            sections = [_dataSource numberOfSectionsInHorizonTableView:self];
        }
    }
    for (int i=0; i<sections; i++) {
        HorizonTableViewSection *section = [[HorizonTableViewSection alloc]init];
        CGFloat sectionHeaderWidth = 0;
        CGFloat sectionFooterWidth = 0;
        UIView *sectionHeadView = nil;
        UIView *sectionFootView = nil;
        NSUInteger colunmNums = 0;
        
        if (_dataSource) {
            if ([_dataSource conformsToProtocol:@protocol(HorizonTableViewDataSource)] && [_dataSource respondsToSelector:@selector(horizonTableView:numberOfColunmsInSection:)]) {
                colunmNums = [_dataSource horizonTableView:self numberOfColunmsInSection:i];
            }
        }
        
        if (_horizonDelegate) {
            if ([_horizonDelegate conformsToProtocol:@protocol(HorizonTableViewDelegate)] && [_horizonDelegate respondsToSelector:@selector(horizonTableView:widthForHeaderInSection:)]) {
                sectionHeaderWidth = [_horizonDelegate horizonTableView:self widthForHeaderInSection:i];
            }
            if ([_horizonDelegate conformsToProtocol:@protocol(HorizonTableViewDelegate)] && [_horizonDelegate respondsToSelector:@selector(horizonTableView:widthForFooterInSection:)]) {
                sectionFooterWidth = [_horizonDelegate horizonTableView:self widthForFooterInSection:i];
            }
            
            if ([_horizonDelegate conformsToProtocol:@protocol(HorizonTableViewDelegate)] && [_horizonDelegate respondsToSelector:@selector(horizonTableView:viewForHeaderInSection:)]) {
                sectionHeadView = sectionHeaderWidth>0?[_horizonDelegate horizonTableView:self viewForHeaderInSection:i]:nil;
            }
            
            if ([_horizonDelegate conformsToProtocol:@protocol(HorizonTableViewDelegate)] && [_horizonDelegate respondsToSelector:@selector(horizonTableView:viewForFooterInSection:)]) {
                sectionFootView = sectionFooterWidth>0?[_horizonDelegate horizonTableView:self viewForFooterInSection:i]:nil;
            }
        }
        
        if (_dataSource) {
            if ([_dataSource conformsToProtocol:@protocol(HorizonTableViewDataSource)] && [_dataSource respondsToSelector:@selector(horizonTableView:titleForHeadInSection:)]) {
                if (sectionHeadView == nil && sectionHeaderWidth>0) {
                    sectionHeadView = [HorizonTableViewSectionLabel sectionLabelWithTitle:[_dataSource horizonTableView:self titleForHeadInSection:i]];
                }
            }
            if ([_dataSource conformsToProtocol:@protocol(HorizonTableViewDataSource)] && [_dataSource respondsToSelector:@selector(horizonTableView:titleForFootInSection:)]) {
                if (sectionFootView == nil && sectionFooterWidth>0) {
                    sectionFootView = [HorizonTableViewSectionLabel sectionLabelWithTitle:[_dataSource horizonTableView:self titleForFootInSection:i]];
                }
            }
            
        }
        
        if (sectionHeadView) {
           
            [self addSubview:sectionHeadView];
        }
        else {
            sectionHeaderWidth = 0;
        }
        
        if (sectionFootView) {
            [self addSubview:sectionFootView];
        }
        else {
            sectionFooterWidth = 0;
        }
        
        CGFloat *colunmnWidth = malloc(colunmNums * sizeof(CGFloat));
        CGFloat totalColumnWidth = 0;
        for (int j=0; j<colunmNums; j++) {
            if (_horizonDelegate) {
                if ([_horizonDelegate conformsToProtocol:@protocol(HorizonTableViewDelegate)] && [_horizonDelegate respondsToSelector:@selector(horizonTableView:widthForColumnAtIndexPath:)]) {
                    colunmnWidth[j] = [_horizonDelegate horizonTableView:self widthForColumnAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]]?:HorizonTableViewDefaultColumnWidth;
                    totalColumnWidth += colunmnWidth[j];
                }
            }
        }
        [section setNumberOfColumns:colunmNums withWidths:colunmnWidth];
        section.columnWidths = totalColumnWidth;
        section.headerWidth = sectionHeaderWidth;
        section.footerWidth = sectionFooterWidth;
        section.headerView = sectionHeadView;
        section.footerView = sectionFootView;
        [self.sections addObject:section];
    }
}

// should be called by reloadData, setFrame, header/footer setters.
- (void)setContentSize
{
    [self updateSectionCacheIfNeeded];
    CGFloat width = 0;
    CGFloat headWidth = _tableHeadView?_tableHeadView.frame.size.width:0;
    width += headWidth;
    for (HorizonTableViewSection* section in self.sections) {
        width += section.sectionWidth;
    }
    CGFloat footWidth = _tableFootView?_tableFootView.frame.size.width:0;
    width += footWidth;
    self.contentSize = CGSizeMake(width, self.bounds.size.height);
}

- (void)setTableHeadView:(UIView *)newHeader
{
    if (newHeader != _tableHeadView) {
        [_tableHeadView removeFromSuperview];
        _tableHeadView = newHeader;
        [self setContentSize];
        [self addSubview:_tableHeadView];
    }
}

- (void)setTableFootView:(UIView *)newFooter
{
    if (newFooter != _tableFootView) {
        [_tableFootView removeFromSuperview];
        _tableFootView = newFooter;
        [self setContentSize];
        [self addSubview:_tableFootView];
    }
}

- (HorizonTableViewCell*)dequeueReusableCellWithIdentifier:(NSString*)indentifier {
    for (HorizonTableViewCell *cell in self.reuseCell) {
        if ([cell.identifier isEqualToString:indentifier]) {
            [self.reuseCell removeObject:cell];
            return cell;
        }
    }
    return nil;
}

- (void)reloadData {
    [[self.cacheCells allValues]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.reuseCell makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.cacheCells removeAllObjects];
    [self.reuseCell removeAllObjects];
    [self updateSectionCache];
    [self setContentSize];
    self.needsReload = NO;
}

- (CGRect)fromOffset:(CGFloat)offset withWidth:(CGFloat)width
{
    return CGRectMake(offset, 0, width, self.frame.size.height);
}

- (CGFloat)offsetForSection:(NSInteger)section
{
    CGFloat offset = 0;
    if (_tableHeadView) {
        offset = _tableHeadView.frame.size.width;
    }
    for (int i=0; i<section; i++) {
        offset += [self.sections[i] sectionWidth];
    }
    return offset;
}

- (CGRect)rectForCell:(NSIndexPath*)indexPath
{
    CGFloat offset = [self offsetForSection:indexPath.section];
    HorizonTableViewSection *sectionModel = self.sections[indexPath.section];
    offset += sectionModel.headerWidth;
    for (int i=0; i<indexPath.row; i++) {
        offset += [self.sections[indexPath.section] columnsWidth][i];
    }
    return [self fromOffset:offset withWidth:[self.sections[indexPath.section] columnsWidth][indexPath.row]];
}

- (CGRect)rectForHeaderInSection:(NSInteger)section
{
    HorizonTableViewSection *sectionTemp = self.sections[section];
    CGFloat offset = [self offsetForSection:section];
    return [self fromOffset:offset withWidth:sectionTemp.headerWidth];
}

- (CGRect)rectForFooterInSection:(NSInteger)section
{
    HorizonTableViewSection *sectionTemp = self.sections[section];
    CGFloat offset = [self offsetForSection:section];
    return [self fromOffset:offset+sectionTemp.headerWidth+sectionTemp.columnWidths withWidth:sectionTemp.footerWidth];
}

- (CGRect)rectForSection:(NSInteger)section
{
    HorizonTableViewSection *sectionTemp = self.sections[section];
    CGFloat offset = [self offsetForSection:section];
    return [self fromOffset:offset withWidth:sectionTemp.sectionWidth];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   
}
@end
