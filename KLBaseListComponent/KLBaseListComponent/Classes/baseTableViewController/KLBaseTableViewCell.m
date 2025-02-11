//
//  KLBaseTableViewCell.m
//  SHCommonTool_Example
//
//  Created by mac on 2023/10/8.
//  Copyright © 2023 keith. All rights reserved.
//

#import "KLBaseTableViewCell.h"

@implementation KLBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self == nil) return self;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self override_setupSubViews];
    
    return self;
}

- (void)override_setupSubViews {
    //[self doesNotRecognizeSelector:_cmd];
}

- (void)override_reloadTableCell:(KLListViewCellModel *)cellModel {
    //[self doesNotRecognizeSelector:_cmd];
}

@end
