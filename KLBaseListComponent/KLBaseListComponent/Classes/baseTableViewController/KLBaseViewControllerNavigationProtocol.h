//
//  KLBaseViewControllerNavigationProtocol.h
//  KLBaseListComponent
//
//  Created by admin on 2025/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KLBaseViewControllerNavigationProtocol <NSObject>

- (BOOL)ds_showCustomNavigationBar;
- (NSString *)ds_titleForNavigationBar;
- (UIColor *)ds_colorForNavigationBar;

@end

NS_ASSUME_NONNULL_END
