//
//  KLBaseTableViewController.h
//  SHCommonTool_Example
//
//  Created by mac on 2023/10/8.
//  Copyright © 2023 keith. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KLListViewModel.h"
#import "KLBaseTableViewCell.h"
#import "KLBaseTableSectionHeaderFooterView.h"
#import "KLBaseTableViewControllerProtocol.h"

#import "KLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KLBaseTableViewController : KLBaseViewController
<UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching,

KLBaseTableViewControllerDataSource,
KLBaseTableViewControllerEmptyView,
KLBaseTableViewControllerRefresh>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) KLListViewModel *tableViewModel;












//TODO: ~~~待抽象，~~~待抽象，~~~待抽象，~~~待抽象，
@property (nonatomic, assign) NSUInteger currentPage;
/// NSArray *arr = [NSArray yy_modelArrayWithClass:[SHLivePKRecordModel class] json:responseObject[@"data"][@"data"]];
/// 待处理这种数据格式


@end

NS_ASSUME_NONNULL_END
