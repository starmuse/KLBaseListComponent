//
//  KLBaseCollectionViewController.h
//  SHCommonTool_Example
//
//  Created by admin on 2024/10/10.
//  Copyright © 2024 keith. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KLListViewModel.h"
#import "KLBaseCollectionViewCell.h"
#import "KLBaseCollectionReusableView.h"

#import "KLBaseCollectionViewControllerProtocol.h"

NS_ASSUME_NONNULL_BEGIN






@interface KLBaseCollectionViewController : UIViewController
<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,
KLBaseCollectionViewControllerDataSource,
KLBaseCollectionViewControllerEmptyView>

@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, strong, readonly) KLListViewModel *collectionViewModel;

@end

NS_ASSUME_NONNULL_END
