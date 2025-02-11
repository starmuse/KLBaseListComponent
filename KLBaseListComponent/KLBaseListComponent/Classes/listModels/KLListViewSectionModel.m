//
//  KLListViewSectionModel.m
//  SHCommonTool_Example
//
//  Created by admin on 2024/10/9.
//  Copyright © 2024 keith. All rights reserved.
//

#import "KLListViewSectionModel.h"

@implementation KLListViewSectionModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"cells" : KLListViewCellModel.class
    };
}

- (NSMutableArray<KLListViewCellModel *> *)cells {
    if (_cells == nil) {
        _cells = @[].mutableCopy;
    }
    return _cells;
}

@end

@implementation KLListViewSectionInfoModel

@end

@implementation KLListViewSectionHeaderFooterModel

@end

@implementation KLListViewCellModel

@end
