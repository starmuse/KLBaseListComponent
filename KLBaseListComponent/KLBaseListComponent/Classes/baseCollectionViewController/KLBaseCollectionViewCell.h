//
//  KLBaseCollectionViewCell.h
//  SHCommonTool_Example
//
//  Created by admin on 2024/10/10.
//  Copyright © 2024 keith. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KLListViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KLBaseCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath *sh_indexPath;
@property (nonatomic, weak) UIViewController *sh_currentViewController;
@property (nonatomic, strong) KLListViewCellModel *sh_cellModel;
@property (nonatomic, weak) id delegate;

- (void)override_setupSubviews;

- (void)override_reloadCollectionCell:(KLListViewCellModel *)cellModel;

@end

NS_ASSUME_NONNULL_END
