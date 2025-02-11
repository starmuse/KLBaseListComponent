//
//  KLBaseTableViewControllerProtocol.h
//  IOSGmSDK
//
//  Created by admin on 2023/10/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KLBaseTableViewControllerDataSource <NSObject>

@required
- (NSArray<Class> *)ds_classesRegistionForTableCell;

@optional
- (__kindof KLListViewModel *)ds_listViewModelForListController;
- (UITableViewStyle)ds_tableViewStyle; // 样式默认为Plain
- (Class)ds_tableViewClass;// 使用自定义的 UITableView 子类

- (NSArray<Class> *)ds_classesRegistionForSectionHeader; // 使用UITableViewHeaderFooterView的子类
- (NSArray<Class> *)ds_classesRegistionForSectionFooter; // 使用UITableViewHeaderFooterView的子类

///设置预估高度
- (CGFloat)ds_estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(7.0));
- (CGFloat)ds_estimatedHeightForHeaderInSection:(NSInteger)section API_AVAILABLE(ios(7.0));
- (CGFloat)ds_estimatedHeightForFooterInSection:(NSInteger)section API_AVAILABLE(ios(7.0));


///提供header
- (__kindof UIView *)ds_tableViewHeader;
///提供footer
- (__kindof UIView *)ds_tableViewFooter;


///默认添加底部偏移 KLSafeAreaBottomHeight
- (UIEdgeInsets)ds_tableViewContentInset;


/// section 设置圆角，默认不切
- (BOOL)ds_shouldRoundCornersForSection:(NSInteger)section;
- (CGFloat)ds_cornerRadiusForSection:(NSInteger)section;
- (UIEdgeInsets)ds_insetsForSection:(NSInteger)section;

@end




#pragma mark - Protocol: KLBaseTableViewControllerEmptyView

@protocol KLBaseTableViewControllerEmptyView <NSObject>
///默认开启tableView的自动空视图功能
- (BOOL)ds_emptyViewEnabled;
- (NSString *)ds_titleTextForDefaultEmptyView;
- (UIImage *)ds_imageForDefaultEmptyView;
@end






#pragma mark - Protocol: 子类若要实现下拉刷新时，实现此协议的方法，为当前tableViewController提供所需的设置

@protocol KLBaseTableViewControllerRefresh <NSObject>
@optional
- (BOOL)ds_showRefreshTableViewHeader;
- (BOOL)ds_showRefreshTableViewFooter;
- (void)ds_requestDataWithRefresh:(BOOL)isRefresh;
@end

NS_ASSUME_NONNULL_END
