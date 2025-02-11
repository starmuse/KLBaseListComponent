//
//  KLBaseTableViewController.m
//  SHCommonTool_Example
//
//  Created by mac on 2023/10/8.
//  Copyright © 2023 keith. All rights reserved.
//

#import "KLBaseTableViewController.h"

#import "UIView+Categories.h"
#import <Masonry/Masonry.h>
#import <LYEmptyView/LYEmptyViewHeader.h>
#import "KLBaseListComponentDefines.h"
#import "UIScrollView+Refresh.h"

@interface KLBaseTableViewController ()

@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, strong, readwrite) KLListViewModel *tableViewModel;

@end

@implementation KLBaseTableViewController

- (void)dealloc { NSLog(@"%@ - %s 已释放", self.class, __FUNCTION__); }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentPage = 1; //请求页面的初始以1开始，不允许设置为0
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        if ([self ds_showCustomNavigationBar]) {
            make.top.mas_equalTo(self.zx_navBar.mas_bottom);
        } else {
            make.top.mas_equalTo(self.mas_topLayoutGuide);
        }
        make.bottom.mas_equalTo(self.view);
    }];
    
    if ([self respondsToSelector:@selector(ds_tableViewContentInset)]) {
        self.tableView.contentInset = [self ds_tableViewContentInset];
    }
    
    if ([self respondsToSelector:@selector(ds_tableViewHeader)] && [self ds_tableViewHeader] != nil) {
        self.tableView.tableHeaderView = [self ds_tableViewHeader];
    }
    
    if ([self respondsToSelector:@selector(ds_tableViewFooter)] && [self ds_tableViewFooter] != nil) {
        self.tableView.tableFooterView = [self ds_tableViewFooter];
    }
    
    if ([self respondsToSelector:@selector(ds_emptyViewEnabled)] && [self ds_emptyViewEnabled]) {
        //不要reload，页面显示顺序不对的
        //[self.tableView reloadEmptyDataSet];
    }
}

#pragma mark - KLBaseTableViewControllerNavigation.

- (BOOL)ds_showCustomNavigationBar {
    return YES;
}

- (NSString *)ds_titleForNavigationBar {
    return nil;
}


#pragma mark - implementation by subclasses. 不能像swift提供协议的默认实现，这里先继承提供默认实现.

- (Class)ds_tableViewClass {
    return nil;
}

- (__kindof KLListViewModel *)ds_listViewModelForListController {
    return nil;
}

//- (NSArray<UITableViewHeaderFooterView *> *)ds_classesRegistionForSectionHeader {
//    return @[];
//}
//
//- (NSArray<UITableViewHeaderFooterView *> *)ds_classesRegistionForSectionFooter {
//    return @[];
//}

- (UITableViewStyle)ds_tableViewStyle {
    return UITableViewStylePlain;
}

- (BOOL)ds_shouldRoundCornersForSection:(NSInteger)section {
    return NO;
}

- (CGFloat)ds_cornerRadiusForSection:(NSInteger)section {
    return 8.0;
}

- (UIEdgeInsets)ds_insetsForSection:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (__kindof UIView *)ds_tableViewHeader {
    return nil;
}

- (__kindof UIView *)ds_tableViewFooter {
    return nil;
}

- (UIEdgeInsets)ds_tableViewContentInset {
    return UIEdgeInsetsMake(0, 0, KLSafeAreaBottomHeight, 0);
}

#pragma mark - UITableViewDataSource. UITableViewDelegate.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableViewModel.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewModel.sections[section].cells.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self respondsToSelector:@selector(ds_estimatedHeightForRowAtIndexPath:)]) {
        return [self ds_estimatedHeightForRowAtIndexPath:indexPath];
    }
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    
    if ([self respondsToSelector:@selector(ds_estimatedHeightForHeaderInSection:)]) {
        return [self ds_estimatedHeightForHeaderInSection:section];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    
    if ([self respondsToSelector:@selector(ds_estimatedHeightForFooterInSection:)]) {
        [self ds_estimatedHeightForFooterInSection:section];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    KLListViewSectionModel *sectionModel = self.tableViewModel.sections[section];
    Class sectionHeaderClass = sectionModel.header.headerFooter_class;
    NSString *headerClassName = NSStringFromClass(sectionHeaderClass);
    if (headerClassName == nil || headerClassName.length == 0) {
        return nil;
    }
    NSString *headerIdentifier = [headerClassName stringByAppendingString:@"_identifier"];
    
    KLBaseTableSectionHeaderFooterView *header = (KLBaseTableSectionHeaderFooterView *)sectionHeaderClass;
    header = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];

    header.sh_section = section;
    header.sh_model = sectionModel.header;
    header.delegate = self;

    [header override_reloadTableSectionHeaderFooter:sectionModel.header];
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    KLListViewSectionModel *sectionModel = self.tableViewModel.sections[section];
    Class sectionFooterClass = sectionModel.footer.headerFooter_class;
    NSString *footerClassName = NSStringFromClass(sectionFooterClass);
    if (footerClassName == nil || footerClassName.length == 0) {
        return nil;
    }
    NSString *footerIdentifier = [footerClassName stringByAppendingString:@"_identifier"];
    
    KLBaseTableSectionHeaderFooterView *footer = (KLBaseTableSectionHeaderFooterView *)sectionFooterClass;
    footer = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:footerIdentifier];

    footer.sh_section = section;
    footer.sh_model = sectionModel.footer;
    footer.delegate = self;

    [footer override_reloadTableSectionHeaderFooter:sectionModel.footer];
    
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSAssert1([self respondsToSelector:@selector(ds_classesRegistionForTableCell)],
              @"Must implement protocol Method (ds_classesRegistionForTableCell) by %@", self.class);
    
    if (indexPath.section >= self.tableViewModel.sections.count) {
        NSLog(@"Invalid section: %ld", (long)indexPath.section);
        return [[UITableViewCell alloc] init];
    }
    
    KLListViewCellModel *cellModel = self.tableViewModel.sections[indexPath.section].cells[indexPath.row];
    NSString *cellClassName = NSStringFromClass(cellModel.cell_class);
    NSString *cellIdentifier = [cellClassName stringByAppendingString:@"_identifier"];
    
    KLBaseTableViewCell *cell = (KLBaseTableViewCell *)cellModel.cell_class;
    cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.sh_indexPath = indexPath;
    cell.sh_cellModel = cellModel;
    cell.delegate = self;
    cell.sh_currentController = self;
    
    [cell override_reloadTableCell:cellModel];
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
//    
//}
//
//- (void)tableView:(UITableView *)tableView cancelPrefetchingForRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
//    
//}




// MARK: - sectionHeader cell sectionFooter 圆角设置

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    BOOL shouldRoundCorners = [self respondsToSelector:@selector(ds_shouldRoundCornersForSection:)] && [self ds_shouldRoundCornersForSection:section];
    if (!shouldRoundCorners) return;
    
    view.layer.mask = nil;

    CGFloat radius = [self respondsToSelector:@selector(ds_cornerRadiusForSection:)] ? [self ds_cornerRadiusForSection:section] : 0;

    NSInteger rowsInCurrSection = [tableView numberOfRowsInSection:section];
    BOOL hasSectionFooter = ([self tableView:tableView viewForFooterInSection:section] != nil);

    if (rowsInCurrSection == 0 && !hasSectionFooter) {
        [view kl_addRoundedCornersRadius:radius byRoundingCorners:UIRectCornerAllCorners];
    } else if (rowsInCurrSection == 0 && hasSectionFooter) {
        [view kl_addRoundedCornersRadius:radius byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    } else if (rowsInCurrSection > 0) {
        [view kl_addRoundedCornersRadius:radius byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    
    BOOL shouldRoundCorners = [self respondsToSelector:@selector(ds_shouldRoundCornersForSection:)] && [self ds_shouldRoundCornersForSection:section];
    if (!shouldRoundCorners) return;
    
    view.layer.mask = nil;

    CGFloat radius = [self respondsToSelector:@selector(ds_cornerRadiusForSection:)] ? [self ds_cornerRadiusForSection:section] : 0;
    
    NSInteger rowsInCurrSection = [tableView numberOfRowsInSection:section];
    BOOL hasSectionHeader = ([self tableView:tableView viewForHeaderInSection:section] != nil);

    if (rowsInCurrSection == 0 && !hasSectionHeader) {
        [view kl_addRoundedCornersRadius:radius byRoundingCorners:UIRectCornerAllCorners];
    } else if (rowsInCurrSection == 0 && hasSectionHeader) {
        [view kl_addRoundedCornersRadius:radius byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)];
    } else if (rowsInCurrSection > 0) {
        [view kl_addRoundedCornersRadius:radius byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL shouldRoundCorners = [self respondsToSelector:@selector(ds_shouldRoundCornersForSection:)] && [self ds_shouldRoundCornersForSection:indexPath.section];
    if (!shouldRoundCorners) return;
    
    cell.layer.mask = nil;
    
    CGFloat radius = [self respondsToSelector:@selector(ds_cornerRadiusForSection:)] ? [self ds_cornerRadiusForSection:indexPath.section] : 0;

    NSInteger rowsInCurrSection = [tableView numberOfRowsInSection:indexPath.section];
    BOOL hasSectionHeader = ([self tableView:tableView viewForHeaderInSection:indexPath.section] != nil);
    BOOL hasSectionFooter = ([self tableView:tableView viewForFooterInSection:indexPath.section] != nil);

    if (indexPath.row == 0 && !hasSectionHeader) {
        [cell kl_addRoundedCornersRadius:radius byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    }
    
    if (indexPath.row == rowsInCurrSection - 1 && !hasSectionFooter) {
        [cell kl_addRoundedCornersRadius:radius byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)];
    }
}





#pragma mark - protocol: KLBaseTableViewControllerEmptyView.

- (BOOL)ds_emptyViewEnabled {
    return YES;
}

- (NSString *)ds_titleTextForDefaultEmptyView {
    return @"暂无相关数据~";
}

- (UIImage *)ds_imageForDefaultEmptyView {
    return [UIImage imageNamed:@"empty_data"];
}






#pragma mark - protocol: KLBaseTableViewControllerRefresh.

- (BOOL)ds_showRefreshTableViewHeader { return YES; }

- (BOOL)ds_showRefreshTableViewFooter { return YES; }

- (void)ds_requestDataWithRefresh:(BOOL)isRefresh {
    
    if ([self respondsToSelector:@selector(ds_showRefreshTableViewFooter)] ||
        [self respondsToSelector:@selector(ds_showRefreshTableViewHeader)]) {
        
        [self doesNotRecognizeSelector:_cmd];
    }
}

#pragma mark - properies：getters setters

- (UITableView *)tableView {
    
    if (_tableView == nil) {
        
        if ([self ds_tableViewClass]) {
            Class cls = [self ds_tableViewClass];
            _tableView = (UITableView *)[[cls alloc] init];
            //_tableView.style = [self ds_tableViewStyle];
        } else {
            _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:[self ds_tableViewStyle]];
        }
        
        _tableView.backgroundColor = [UIColor clearColor];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        if (@available(iOS 10.0, *)) {
            _tableView.prefetchDataSource = self;
        }
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        _tableView.sectionFooterHeight = UITableViewAutomaticDimension;
        
        ///tableView上的空视图功能控制
        if ([self respondsToSelector:@selector(ds_emptyViewEnabled)]) {
            _tableView.ly_emptyView.autoShowEmptyView = [self ds_emptyViewEnabled];
        }
        
        ///tableView上的刷新加载功能控制
        if ([self respondsToSelector:@selector(ds_showRefreshTableViewHeader)] && [self ds_showRefreshTableViewHeader]) {
            __weak typeof(self) weakSelf = self;
            [_tableView addPullToRefreshWithActionHandler:^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if ([strongSelf respondsToSelector:@selector(ds_requestDataWithRefresh:)]) {
                    [strongSelf ds_requestDataWithRefresh:YES];
                }
            }];
        }
        if ([self respondsToSelector:@selector(ds_showRefreshTableViewFooter)] && [self ds_showRefreshTableViewFooter]) {
            __weak typeof(self) weakSelf = self;
            [_tableView addInfiniteScrollingWithActionHandler:^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if ([strongSelf respondsToSelector:@selector(ds_requestDataWithRefresh:)]) {
                    [strongSelf ds_requestDataWithRefresh:NO];
                }
            }];
        }
        
        
        
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//            _tableView.estimatedSectionHeaderHeight = 0;
//            _tableView.estimatedSectionFooterHeight = 0;
        }
        
        if (@available(iOS 15.0, *)) {
            /// Padding above each section header. The default value is `UITableViewAutomaticDimension`.
            _tableView.sectionHeaderTopPadding = 0;
        }
        
        // register cells.
        NSAssert1([self respondsToSelector:@selector(ds_classesRegistionForTableCell)],
                  @"Must implement protocol Method (ds_classesRegistionForTableCell) by %@", self.class);
        
        NSSet<Class> *cellClassesSet = [NSSet setWithArray:[self ds_classesRegistionForTableCell]];
        [cellClassesSet enumerateObjectsUsingBlock:^(Class cellClass, BOOL * _Nonnull stop) {
            NSString *cellClassName = NSStringFromClass(cellClass);
            NSString *cellIdentifier = [cellClassName stringByAppendingString:@"_identifier"];
            [_tableView registerClass:cellClass forCellReuseIdentifier:cellIdentifier];
        }];
        
        // register section headers.
        if ([self respondsToSelector:@selector(ds_classesRegistionForSectionHeader)]) {
            NSSet<Class> *headerClassesSet = [NSSet setWithArray:[self ds_classesRegistionForSectionHeader]];
            [headerClassesSet enumerateObjectsUsingBlock:^(Class  _Nonnull headerClass, BOOL * _Nonnull stop) {
                NSString *headerClassName = NSStringFromClass(headerClass);
                NSString *headerIdentifier = [headerClassName stringByAppendingString:@"_identifier"];
                [_tableView registerClass:headerClass forHeaderFooterViewReuseIdentifier:headerIdentifier];
            }];
        }
        
        // register section footers
        if ([self respondsToSelector:@selector(ds_classesRegistionForSectionFooter)]) {
            NSSet<Class> *footerClassesSet = [NSSet setWithArray:[self ds_classesRegistionForSectionFooter]];
            [footerClassesSet enumerateObjectsUsingBlock:^(Class _Nonnull footerClass, BOOL * _Nonnull stop) {
                NSString *footerClassName = NSStringFromClass(footerClass);
                NSString *footerIdentifier = [footerClassName stringByAppendingString:@"_identifier"];
                [_tableView registerClass:footerClass forHeaderFooterViewReuseIdentifier:footerIdentifier];
            }];
        }
    }
    
    return _tableView;
}

- (KLListViewModel *)tableViewModel {
    KLListViewModel *temporaryModel = _tableViewModel;
    
    if (temporaryModel == nil) {
        if ([self respondsToSelector:@selector(ds_listViewModelForListController)] &&
            [self ds_listViewModelForListController] != nil &&
            [[self ds_listViewModelForListController] isKindOfClass:KLListViewModel.class]) {
            
            temporaryModel = [self ds_listViewModelForListController];
            _tableViewModel = temporaryModel;
        } else {
            _tableViewModel = [[KLListViewModel alloc] init];
        }
    }
    return _tableViewModel;
}

///项目是从1开始的页面刷新
- (NSUInteger)currentPage {
    if (_currentPage == 0) {
        _currentPage = 1;
    }
    return _currentPage;
}

@end
