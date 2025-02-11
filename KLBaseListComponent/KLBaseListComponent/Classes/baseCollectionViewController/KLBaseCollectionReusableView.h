//
//  KLBaseCollectionReusableView.h
//  SHCommonTool_Example
//
//  Created by admin on 2024/10/10.
//  Copyright © 2024 keith. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KLListViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KLBaseCollectionReusableView : UICollectionReusableView

@property (nonatomic, assign) NSInteger sh_section;
@property (nonatomic, weak) UIViewController *sh_currentViewController;
@property (nonatomic, strong) KLListViewSectionHeaderFooterModel *sh_headerFooterModel;
@property (nonatomic, weak) id delegate;

- (void)override_setupSubviews;

- (void)override_reloadCollectionSectionHeaderFooter:(KLListViewSectionHeaderFooterModel *)sectionHeaderFooterModel;

@end

NS_ASSUME_NONNULL_END
