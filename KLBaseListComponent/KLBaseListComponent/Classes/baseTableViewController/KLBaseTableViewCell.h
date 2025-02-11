//
//  KLBaseTableViewCell.h
//  SHCommonTool_Example
//
//  Created by mac on 2023/10/8.
//  Copyright © 2023 keith. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KLListViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KLBaseTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *sh_indexPath;
@property (nonatomic, strong) __kindof KLListViewCellModel *sh_cellModel;
@property (nonatomic, weak) id delegate;

@property (nonatomic, weak) __kindof UIViewController *sh_currentController;

- (void)override_setupSubViews;

- (void)override_reloadTableCell:(KLListViewCellModel *)cellModel;

@end

NS_ASSUME_NONNULL_END
