//
//  KLBaseCollectionReusableView.m
//  SHCommonTool_Example
//
//  Created by admin on 2024/10/10.
//  Copyright © 2024 keith. All rights reserved.
//

#import "KLBaseCollectionReusableView.h"

@implementation KLBaseCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self override_setupSubviews];
    }
    return self;
}

- (void)override_setupSubviews {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)override_reloadCollectionSectionHeaderFooter:(KLListViewSectionHeaderFooterModel *)sectionHeaderFooterModel {
    [self doesNotRecognizeSelector:_cmd];
}


@end
