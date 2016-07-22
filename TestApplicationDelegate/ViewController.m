//
//  ViewController.m
//  TestApplicationDelegate
//
//  Created by ZhangShan on 16/6/15.
//  Copyright © 2016年 ZhangShan. All rights reserved.
//

#import "ViewController.h"
#import "HorizonTableView.h"

static NSString* const reuseIdentifier = @"haha";

@interface ViewController ()<HorizonTableViewDataSource,HorizonTableViewDelegate>

@property (nonatomic,strong) HorizonTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation ViewController

- (void)commonInit
{
    for (int i=0; i<4; i++) {
        NSMutableArray *arrayTemp = [NSMutableArray arrayWithCapacity:0];
        for (int j=0; j<10; j++) {
            [arrayTemp addObject:[NSString stringWithFormat:@"测试%d",j]];
        }
        [self.dataArray addObject:arrayTemp];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self commonInit];
    self.tableView = [[HorizonTableView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height-100)];
    self.tableView.dataSource = self;
    self.tableView.horizonDelegate = self;
    
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 50)];
    headLabel.text = @"标题head";
    self.tableView.tableHeadView = headLabel;
    
    UILabel *footLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 50)];
    footLabel.text = @"标题foot";
    self.tableView.tableFootView = footLabel;
    
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (NSInteger)horizonTableView:(HorizonTableView *)tableView numberOfColunmsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (NSInteger)numberOfSectionsInHorizonTableView:(HorizonTableView *)tableView {
    return self.dataArray.count;
}

- (HorizonTableViewCell*)horizonTableView:(HorizonTableView *)tableView cellAtIndexPath:(NSIndexPath *)indexPath
{
    HorizonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
        cell = [[HorizonTableViewCell alloc]init];
        cell.identifier = reuseIdentifier;
    }
    cell.titleLabel.text = self.dataArray[indexPath.section][indexPath.row];
    cell.titleLabel.textColor = [UIColor blackColor];
    return cell;
}

- (CGFloat)horizonTableView:(HorizonTableView *)tableView widthForColumnAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UIView*)horizonTableView:(HorizonTableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 0)];
    sectionLabel.text = @"内部section";
    return sectionLabel;
}

- (CGFloat)horizonTableView:(HorizonTableView *)tableView widthForHeaderInSection:(NSInteger)section {
    return 100;
}

- (UIView*)horizonTableView:(HorizonTableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 0)];
    sectionLabel.text = @"内部sectionFooter";
    return sectionLabel;
}

- (CGFloat)horizonTableView:(HorizonTableView *)tableView widthForFooterInSection:(NSInteger)section {
    return 100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
