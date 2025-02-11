//
//  KLBaseTableSectionHeaderFooterView.m
//  SHCommonTool_Example
//
//  Created by mac on 2023/10/8.
//  Copyright © 2023 keith. All rights reserved.
//

#import "KLBaseTableSectionHeaderFooterView.h"

@implementation KLBaseTableSectionHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self override_setupSubviews];
    }
    return self;
}

- (void)override_setupSubviews {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)override_reloadTableSectionHeaderFooter:(KLListViewSectionHeaderFooterModel *)sectionHeaderFooterModel {
    [self doesNotRecognizeSelector:_cmd];
}

@end
