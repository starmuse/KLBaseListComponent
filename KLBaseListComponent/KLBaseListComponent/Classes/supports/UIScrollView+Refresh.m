//
//  UIScrollView+Refresh.m
//  CJListTool
//
//  Created by ChenJie on 2022/7/4.
//

#import "UIScrollView+Refresh.h"

#pragma mark -  方法交换
#import <objc/runtime.h>
void yf_swizzled_instanceMethod(SEL originalSelector, SEL swizzledSelector, Class inClass) {
    Method originalMethod = class_getInstanceMethod(inClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(inClass, swizzledSelector);
    BOOL didAddMethod =
    class_addMethod(inClass,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(inClass,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}





@implementation UIScrollView (Refresh)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class tabClass = [UITableView class];
        yf_swizzled_instanceMethod(@selector(reloadData), @selector(yf_tableRefreshReloadData), tabClass);
        Class collectionClass = [UICollectionView class];
        yf_swizzled_instanceMethod(@selector(reloadData), @selector(yf_collectionRefreshReloadData), collectionClass);
    });
}

- (void)yf_tableRefreshReloadData {
    [self yf_tableRefreshReloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.mj_footer.hidden = ([self yf_totalDataCount] <= 0 && self.mj_header != nil);
    });

}

- (void)yf_collectionRefreshReloadData {
    [self yf_collectionRefreshReloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.mj_footer.hidden = ([self yf_totalDataCount] <= 0 && self.mj_header != nil);
    });
    
}

- (NSInteger)yf_totalDataCount {
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        for (NSInteger section = 0; section < tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
        /// 某些场景下会用section header/footer来展示数据,而cell数量为0
        if (tableView.numberOfSections > 1) {
            totalCount = MAX(tableView.numberOfSections, totalCount);
        }
        
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
        /// 某些场景下会用section header/footer来展示数据,而cell数量为0
        if (collectionView.numberOfSections > 1) {
            totalCount = MAX(collectionView.numberOfSections, totalCount);
        }
    }
    return totalCount;
}

#pragma mark -
- (void)triggerPullToRefresh {
    [self.mj_header beginRefreshing];
}

- (void)stopAnimating {
    [self stopAnimating:self.yf_noMoreData];
}

- (void)stopAnimating:(BOOL)noMoreData {
    
    self.yf_noMoreData = noMoreData;
    
    // header
    if (self.mj_header.state == MJRefreshStateRefreshing) {
        [self.mj_header endRefreshing];
    }
    // footer
    if (self.mj_footer.state == MJRefreshStateRefreshing) {
        if (noMoreData) {
            [self.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.mj_footer endRefreshing];
        }
    }else {
        if (noMoreData) {
            [self.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.mj_footer endRefreshing];
        }
    }
}

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:actionHandler];
    
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    //header.stateLabel.textColor =

//    header.lastUpdatedTimeLabel.font = [UIFont sh_regularFontOfSize:14];
//    header.lastUpdatedTimeLabel.textColor = [UIColor sh_getColorWithHexString:@"#000000" andAlpha:0.4];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    //
    header.labelLeftInset = 14;
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    header.arrowView.image = [UIImage imageNamed:@"sh_common_tool_header_refresh"];
    
    self.mj_header = header;
}

- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler {

    __weak typeof(self) wself = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        if (!sself) {
            return;
        }
        
        BOOL showHandler = NO;
        
        if ([sself isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)sself;
            /// 某些场景下会用section header/footer来展示数据,而cell数量为0
            if ([tableView numberOfSections] > 1) {
                showHandler = YES;
            } else {
                for (NSInteger section = 0; section < [tableView numberOfSections]; section++) {
                    if ([tableView numberOfRowsInSection:section] > 0) {
                        showHandler = YES;
                        break;
                    }
                }
            }
        } else if ([sself isKindOfClass:[UICollectionView class]]) {
            UICollectionView *collectionView = (UICollectionView *)sself;
            /// 某些场景下会用section header/footer来展示数据,而cell数量为0
            if ([collectionView numberOfSections] > 1) {
                showHandler = YES;
            } else {
                for (NSInteger section = 0; section < [collectionView numberOfSections]; section++) {
                    if ([collectionView numberOfItemsInSection:section] > 0) {
                        showHandler = YES;
                        break;
                    }
                }
            }
        } else {
            showHandler = YES;
        }
        
        BOOL isNoMoreData = (sself.mj_footer.state == MJRefreshStateNoMoreData);
        if (showHandler && actionHandler && !isNoMoreData) {
            actionHandler();
        }
    }];

    //footer.stateLabel.textColor = [UIColor sh_getColorWithHexString:@"#000000" andAlpha:0.4];
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载 ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据～" forState:MJRefreshStateNoMoreData];
    footer.labelLeftInset = 14;
    
    self.mj_footer = footer;
}

///
- (void)updateHeaderFooterTextColor:(UIColor *)color {
    
    if (color == nil) {
        return;
    }
    
    if (self.mj_header &&
        [self.mj_header isKindOfClass:[MJRefreshNormalHeader class]]) {
        
        MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)self.mj_header;
        header.stateLabel.textColor = color;
        header.lastUpdatedTimeLabel.textColor = color;
        header.arrowView.image = [UIImage imageNamed:@"sh_common_tool_header_refresh"];
    }
    
    if (self.mj_footer &&
        [self.mj_footer isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        
        MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.mj_footer;
        footer.stateLabel.textColor = color;
    }
    
}

#pragma mark -  set/get

- (BOOL)yf_noMoreData {
    return [objc_getAssociatedObject(self, @selector(yf_noMoreData)) boolValue];
}

- (void)setYf_noMoreData:(BOOL)yf_noMoreData {
    objc_setAssociatedObject(self, @selector(yf_noMoreData), @(yf_noMoreData), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
