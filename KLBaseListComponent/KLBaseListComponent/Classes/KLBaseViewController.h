//
//  KLBaseViewController.h
//  KLBaseListComponent
//
//  Created by admin on 2025/2/11.
//

#import <UIKit/UIKit.h>

#import <ZXNavigationBar/ZXNavigationBarController.h>

NS_ASSUME_NONNULL_BEGIN


@protocol KLBaseViewControllerNavigationProtocol <NSObject>

- (BOOL)ds_showCustomNavigationBar;
- (NSString *)ds_titleForNavigationBar;
- (UIColor *)ds_colorForNavigationBar;

@end



@interface KLBaseViewController : ZXNavigationBarController
<KLBaseViewControllerNavigationProtocol>

@end



NS_ASSUME_NONNULL_END
