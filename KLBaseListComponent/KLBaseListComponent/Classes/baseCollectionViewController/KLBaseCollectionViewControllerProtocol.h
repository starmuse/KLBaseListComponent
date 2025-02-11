//
//  KLBaseCollectionViewControllerProtocol.h
//  IOSGmSDK
//
//  Created by admin on 2024/10/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Protocol: KLBaseCollectionViewControllerDataSource

@protocol KLBaseCollectionViewControllerDataSource <NSObject>

@required
- (NSArray<Class> *)ds_classesRegistionForCollectionCells;
- (__kindof UICollectionViewLayout *)ds_flowLayoutForCollectionView;

@optional
- (__kindof KLListViewModel *)ds_listViewModelForListController;
- (NSArray<Class> *)ds_classesRegistionForCollectionSectionHeader;
- (NSArray<Class> *)ds_classesRegistionForCollectionSectionFooter;
//- (UIEdgeInsets)ds_insetsForSectionAt:(NSInteger)section;
//- (CGFloat)ds_minimumLineSpacingForSectionAt:(NSInteger)section;
//- (CGFloat)ds_miniumumInteritemSpacingForSectionAt:(NSInteger)section;

- (UIEdgeInsets)ds_collectionViewContentInset;///默认添加底部偏移 SHSafeBottomHeight

@end






#pragma mark - Protocol: KLBaseCollectionViewControllerEmptyView

@protocol KLBaseCollectionViewControllerEmptyView <NSObject>
///默认开启
- (BOOL)ds_emptyViewEnabled;
- (NSString *)ds_titleTextForDefaultEmptyView;
- (UIImage *)ds_imageForDefaultEmptyView;
@end




NS_ASSUME_NONNULL_END
