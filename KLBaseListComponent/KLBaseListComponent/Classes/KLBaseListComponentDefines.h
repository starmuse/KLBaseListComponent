//
//  KLBaseListComponentDefines.h
//  KLBaseListComponent
//
//  Created by admin on 2025/2/11.
//

#ifndef KLBaseListComponentDefines_h
#define KLBaseListComponentDefines_h

#import "KLTools.h"
#define KLSafeAreaTopHeight [KLTools kl_safeTopHeight]
#define KLSafeAreaBottomHeight [KLTools kl_safeBottomHeight]



///页面刷新是下拉刷新还是上啦加载更多
typedef NS_ENUM(NSInteger, RefreshType) {
    RefreshTypePullToRefresh,  // 下拉刷新
    RefreshTypeLoadMore        // 上拉加载更多
};























#endif /* KLBaseListComponentDefines_h */
