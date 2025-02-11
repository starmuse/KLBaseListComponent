//
//  KLTestTableViewController.m
//  KLBaseListComponent
//
//  Created by admin on 2025/2/11.
//

#import "KLTestTableViewController.h"
#import "KLTestTableCell.h"
#import "UIScrollView+Refresh.h"

@interface KLTestTableViewController ()

@end

@implementation KLTestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
}




- (NSArray<Class> *)ds_classesRegistionForTableCell {
    return @[KLTestTableCell.class];
}

- (void)ds_requestDataWithRefresh:(BOOL)isRefresh {
    
    self.currentPage = isRefresh ? 1 : self.currentPage + 1;
    
    KLListViewSectionModel *sectionModel;
    if (isRefresh) {
        [self.tableViewModel.sections removeAllObjects];
        sectionModel = [KLListViewSectionModel new];
    } else {
        sectionModel = self.tableViewModel.firstSectionModel;
    }
    
    for (int i = 0; i < 24; i ++) {
        KLListViewCellModel *cellModel = [KLListViewCellModel new];
        cellModel.cell_class = KLTestTableCell.class;
        [sectionModel.cells addObject:cellModel];
    }
    
    if (isRefresh) {
        [self.tableViewModel.sections addObject:sectionModel];
    }
    
//    self.tableView.yf_noMoreData = sectionModel.cells.count <= 0;
//    [self.tableView stopAnimating:YES];
    [self.tableView stopAnimating];
    [self.tableView reloadData];
}

@end
