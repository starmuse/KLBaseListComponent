//
//  KLTestListComponentController.m
//  KLBaseListComponent
//
//  Created by admin on 2025/2/11.
//

#import "KLTestListComponentController.h"
#import "KLTestTableViewController.h"

@interface KLTestListComponentController ()

@end

@implementation KLTestListComponentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (NSString *)ds_titleForNavigationBar {
    return @"测试标题";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.navigationController pushViewController:[KLTestTableViewController new] animated:YES];
}










@end
