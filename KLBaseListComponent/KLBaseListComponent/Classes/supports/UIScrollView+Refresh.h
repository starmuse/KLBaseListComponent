//
//  UIScrollView+Refresh.h
//  CJListTool
//
//  Created by ChenJie on 2022/7/4.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Refresh)

///加载更多的状态
@property (nonatomic, assign) BOOL yf_noMoreData;

/// 触发刷新， 自带拖拽刷新效果
- (void)triggerPullToRefresh;

/// 停止刷新动画
- (void)stopAnimating:(BOOL)noMoreData;
- (void)stopAnimating;

/// 添加下拉刷新
/// @param actionHandler 刷新回调
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;

/// 添加上拉刷新
/// @param actionHandler 刷新回调
- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler;

/// 更新header/footer文字颜色
- (void)updateHeaderFooterTextColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
