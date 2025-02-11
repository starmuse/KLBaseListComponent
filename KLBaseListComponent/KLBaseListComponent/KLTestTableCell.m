//
//  KLTestTableCell.m
//  KLBaseListComponent
//
//  Created by admin on 2025/2/11.
//

#import "KLTestTableCell.h"

@implementation KLTestTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)override_setupSubViews {
    
    self.contentView.backgroundColor = [UIColor redColor];
}

@end
