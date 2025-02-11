//
//  KLBaseCollectionViewController.m
//  SHCommonTool_Example
//
//  Created by admin on 2024/10/10.
//  Copyright © 2024 keith. All rights reserved.
//

#import "KLBaseCollectionViewController.h"

#import "UIView+Categories.h"
#import <Masonry/Masonry.h>
#import <LYEmptyView/LYEmptyViewHeader.h>
#import "KLBaseListComponentDefines.h"
#import "UIScrollView+Refresh.h"

@interface KLBaseCollectionViewController ()

@property (nonatomic, strong, readwrite) UICollectionView *collectionView;
@property (nonatomic, strong, readwrite) KLListViewModel *collectionViewModel;

@end

@implementation KLBaseCollectionViewController

- (void)dealloc { NSLog(@"%@ - %s 已释放", self.class, __FUNCTION__); }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    if ([self respondsToSelector:@selector(ds_collectionViewContentInset)]) {
        self.collectionView.contentInset = [self ds_collectionViewContentInset];
    }
    
}

- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [self ds_flowLayoutForCollectionView];
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.alwaysBounceVertical = YES;
        
        if ([self respondsToSelector:@selector(ds_emptyViewEnabled)]) {
            collectionView.ly_emptyView.autoShowEmptyView = [self ds_emptyViewEnabled];
        }
        
        collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        // 使用纯代码的 cell 类进行注册
        NSAssert([self respondsToSelector:@selector(ds_classesRegistionForCollectionCells)], @"Must implement protocol Method (ds_classesRegistionForCollectionCells) by %@.", NSStringFromClass([self class]));
        
        NSSet<Class> *cellClassesSet = [NSSet setWithArray:[self ds_classesRegistionForCollectionCells]];
        [cellClassesSet enumerateObjectsUsingBlock:^(Class cellClass, BOOL * _Nonnull stop) {
            NSString *cellClassName = NSStringFromClass(cellClass);
            NSString *cellIdentifier = [cellClassName stringByAppendingString:@"_identifier"];
            [collectionView registerClass:cellClass forCellWithReuseIdentifier:cellIdentifier];
        }];
        
        // register section headers.
        if ([self respondsToSelector:@selector(ds_classesRegistionForCollectionSectionHeader)]) {
            NSSet<Class> *headerClassesSet = [NSSet setWithArray:[self ds_classesRegistionForCollectionSectionHeader]];
            [headerClassesSet enumerateObjectsUsingBlock:^(Class  _Nonnull headerClass, BOOL * _Nonnull stop) {
                NSString *headerClassName = NSStringFromClass(headerClass);
                NSString *headerIdentifier = [headerClassName stringByAppendingString:@"_identifier"];
                [collectionView registerClass:headerClass forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
            }];
        }
        
        // register section footers
        if ([self respondsToSelector:@selector(ds_classesRegistionForCollectionSectionFooter)]) {
            NSSet<Class> *footerClassesSet = [NSSet setWithArray:[self ds_classesRegistionForCollectionSectionFooter]];
            [footerClassesSet enumerateObjectsUsingBlock:^(Class _Nonnull footerClass, BOOL * _Nonnull stop) {
                NSString *footerClassName = NSStringFromClass(footerClass);
                NSString *footerIdentifier = [footerClassName stringByAppendingString:@"_identifier"];
                [collectionView registerClass:footerClass forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier];
            }];
        }
        _collectionView = collectionView;
    }
    return _collectionView;
}

// MARK: - 默认实现 BaseCollectionViewControllerDataSource

- (NSArray<Class> *)ds_classesRegistionForCollectionCells {
    return @[UICollectionViewCell.class];
}

- (UICollectionViewFlowLayout *)ds_flowLayoutForCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.estimatedItemSize = CGSizeMake(100, 100);
    return flowLayout;
}

- (__kindof KLListViewModel *)ds_listViewModelForListController {
    return nil;
}

- (NSArray<Class> *)ds_classesRegistionForCollectionSectionHeader {
    return @[];
}

- (NSArray<Class> *)ds_classesRegistionForCollectionSectionFooter {
    return @[];
}

- (UIEdgeInsets)ds_collectionViewContentInset {
    return UIEdgeInsetsMake(0, 0, KLSafeAreaBottomHeight, 0);
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.collectionViewModel.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionViewModel.sections[section].cells.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSAssert1([self respondsToSelector:@selector(ds_classesRegistionForCollectionCells)],
              @"Must implement protocol Method (ds_classesRegistionForCollectionCells) by %@", self.class);
    
    KLListViewCellModel *cellModel = self.collectionViewModel.sections[indexPath.section].cells[indexPath.item];
    
    NSString *cellClassName = NSStringFromClass(cellModel.cell_class);
    NSString *cellIdentifier = [NSString stringWithFormat:@"%@_identifier", cellClassName];
    
    KLBaseCollectionViewCell *cell = (KLBaseCollectionViewCell *)cellModel.cell_class;
    cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (![cellClassName isEqualToString:@"UICollectionViewCell"]) {
        cell.sh_indexPath = indexPath;
        cell.sh_cellModel = cellModel;
        cell.delegate = self;
        cell.sh_currentViewController = self;
        
        [cell override_reloadCollectionCell:cellModel];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        KLListViewSectionHeaderFooterModel *sectionHeaderModel = self.collectionViewModel.sections[indexPath.section].header;
        NSString *sectionHeaderClassName = NSStringFromClass(sectionHeaderModel.headerFooter_class);
        
        NSString *sectionHeaderIdentifier = [NSString stringWithFormat:@"%@_identifier", sectionHeaderClassName];
        KLBaseCollectionReusableView *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderIdentifier forIndexPath:indexPath];
        
        if (![sectionHeaderClassName isEqualToString:@"UICollectionReusableView"]) {
            sectionHeader.sh_section = indexPath.section;
            sectionHeader.sh_headerFooterModel = sectionHeaderModel;
            sectionHeader.delegate = self;
            sectionHeader.sh_currentViewController = self;
            
            [sectionHeader override_reloadCollectionSectionHeaderFooter:sectionHeaderModel];
        }
        
        return sectionHeader;
        
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        
        KLListViewSectionHeaderFooterModel *sectionFooterModel = self.collectionViewModel.sections[indexPath.section].footer;
        NSString *sectionFooterClassName = NSStringFromClass(sectionFooterModel.headerFooter_class);
        
        NSString *sectionFooterIdentifier = [NSString stringWithFormat:@"%@_identifier", sectionFooterClassName];
        KLBaseCollectionReusableView *sectionFooter = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:sectionFooterIdentifier forIndexPath:indexPath];
        
        if (![sectionFooterClassName isEqualToString:@"UICollectionReusableView"]) {
            sectionFooter.sh_section = indexPath.section;
            sectionFooter.sh_headerFooterModel = sectionFooterModel;
            sectionFooter.delegate = self;
            sectionFooter.sh_currentViewController = self;
            
            [sectionFooter override_reloadCollectionSectionHeaderFooter:sectionFooterModel];
        }
        
        return sectionFooter;
    }
    
    return [[UICollectionReusableView alloc] init];
}

- (KLListViewModel *)collectionViewModel {
    KLListViewModel *temporaryModel = _collectionViewModel;
    
    if (temporaryModel == nil) {
        if ([self respondsToSelector:@selector(ds_listViewModelForListController)] &&
            [self ds_listViewModelForListController] != nil &&
            [[self ds_listViewModelForListController] isKindOfClass:KLListViewModel.class]) {
            
            temporaryModel = [self ds_listViewModelForListController];
            _collectionViewModel = temporaryModel;
        } else {
            _collectionViewModel = [[KLListViewModel alloc] init];
        }
    }
    return _collectionViewModel;
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

@end
