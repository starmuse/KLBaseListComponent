//
//  KLListViewModel.h
//  SHCommonTool_Example
//
//  Created by mac on 2024/10/8.
//  Copyright © 2024 keith. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KLListViewSectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KLListViewModel : NSObject

@property (nonatomic, strong) id header;
@property (nonatomic, strong) NSMutableArray<__kindof KLListViewSectionModel *> *sections;
@property (nonatomic, strong) id footer;





///获取第一个sectionModel
@property (nonatomic, strong) KLListViewSectionModel *firstSectionModel;
///获取第一个sectionmodel.cells
@property (nonatomic, strong) NSMutableArray<__kindof KLListViewCellModel *> *firstSectionCellModels;

@end

NS_ASSUME_NONNULL_END
