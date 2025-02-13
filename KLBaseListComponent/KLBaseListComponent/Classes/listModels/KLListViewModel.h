//
//  KLListViewModel.h
//  SHCommonTool_Example
//
//  Created by mac on 2024/10/8.
//  Copyright © 2024 keith. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class KLListViewSectionModel;
@class KLListViewCellModel;
@class KLListViewSectionInfoModel;
@class KLListViewSectionHeaderFooterModel;
@class KLListViewCellModel;

@interface KLListViewModel : NSObject

@property (nonatomic, strong) id header;
@property (nonatomic, strong) NSMutableArray<__kindof KLListViewSectionModel *> *sections;
@property (nonatomic, strong) id footer;


///获取第一个sectionModel
@property (nonatomic, strong) KLListViewSectionModel *firstSectionModel;
///获取第一个sectionmodel.cells
@property (nonatomic, strong) NSMutableArray<__kindof KLListViewCellModel *> *firstSectionCellModels;

@end



@interface KLListViewSectionModel : NSObject

@property (nonatomic, strong) __kindof KLListViewSectionInfoModel *info;
@property (nonatomic, strong) __kindof KLListViewSectionHeaderFooterModel *header;
@property (nonatomic, strong) __kindof KLListViewSectionHeaderFooterModel *footer;
@property (nonatomic, strong) NSMutableArray<__kindof KLListViewCellModel *> *cells;

@end


@interface KLListViewSectionInfoModel : NSObject

@property (nonatomic, copy) NSString *sectionID;
@property (nonatomic, copy) NSString *sectionTitle;
@property (nonatomic, copy) NSString *flag;
@property (nonatomic, strong) id data;

@end

@interface KLListViewSectionHeaderFooterModel : NSObject

@property (nonatomic, strong) Class headerFooter_class;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *flag;
@property (nonatomic, strong) id data;

@end

@interface KLListViewCellModel : NSObject

@property (nonatomic, strong) Class cell_class;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *destination_controller;
@property (nonatomic, strong) id model;
@property (nonatomic, strong) id data;

@end

NS_ASSUME_NONNULL_END
