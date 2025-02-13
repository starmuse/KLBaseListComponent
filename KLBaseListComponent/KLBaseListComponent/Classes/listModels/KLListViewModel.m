//
//  KLListViewModel.m
//  SHCommonTool_Example
//
//  Created by mac on 2024/10/8.
//  Copyright © 2024 keith. All rights reserved.
//

#import "KLListViewModel.h"

@implementation KLListViewModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"sections" : KLListViewSectionModel.class
    };
}

- (NSMutableArray<KLListViewSectionModel *> *)sections {
    if (_sections == nil) {
        _sections = @[].mutableCopy;
    }
    return _sections;
}


- (KLListViewSectionModel *)firstSectionModel {
    if (self.sections.count == 0) {
        return [KLListViewSectionModel new];
    }
    return self.sections.firstObject;
}

- (NSMutableArray<__kindof KLListViewCellModel *> *)firstSectionCellModels {
    if (self.sections.count == 0) {
        return nil;
    }
    
    return self.sections.firstObject.cells;
}

@end



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
