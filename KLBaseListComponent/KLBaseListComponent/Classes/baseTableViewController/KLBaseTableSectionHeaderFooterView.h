//
//  KLBaseTableSectionHeaderFooterView.h
//  SHCommonTool_Example
//
//  Created by mac on 2023/10/8.
//  Copyright © 2023 keith. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KLListViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KLBaseTableSectionHeaderFooterView : UITableViewHeaderFooterView

@property (nonatomic) NSInteger sh_section;
@property (nonatomic, strong) __kindof KLListViewSectionHeaderFooterModel *sh_model;
@property (nonatomic, weak) id delegate;

- (void)override_setupSubviews;

- (void)override_reloadTableSectionHeaderFooter:(KLListViewSectionHeaderFooterModel *)sectionHeaderFooterModel;

@end

NS_ASSUME_NONNULL_END
