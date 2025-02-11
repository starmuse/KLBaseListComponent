//
//  KLBaseViewController.m
//  KLBaseListComponent
//
//  Created by admin on 2025/2/11.
//

#import "KLBaseViewController.h"

@interface KLBaseViewController ()

@end

@implementation KLBaseViewController

- (void)dealloc { NSLog(@"%@ - %s 已释放", self.class, __FUNCTION__); }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self ds_showCustomNavigationBar]) {
        /*
         ZXNavigationBar会自动显示返回按钮，且实现点击pop功能，您无需设置，若需要自定义返回按钮，直接覆盖self.zx_navLeftBtn的图片和点击回调即可
         如果项目中存在黑白状态栏交替的需求，建议先在base控制器的viewDidLoad方法中统一设置状态栏颜色，以避免设置成白色状态栏后返回上一个页面无法自动恢复为黑色状态栏
         */
        self.zx_navStatusBarStyle = ZXNavStatusBarStyleDefault;
        
        //在跳转到使用系统导航栏的页面（如系统相册、icloud drive）出现控制器内容上移被系统导航栏遮挡的问题时，请在跳转前设置
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        
        ///统一设置导航栏样式
        self.zx_backBtnImageName = @"nav_back_ic";
        self.zx_navLeftBtn.adjustsImageWhenHighlighted = NO;
        self.zx_navTitle = [self respondsToSelector:@selector(ds_titleForNavigationBar)] ? [self ds_titleForNavigationBar] : @"";
        self.zx_navBarBackgroundColor = [self respondsToSelector:@selector(ds_colorForNavigationBar)] ? [self ds_colorForNavigationBar] : [UIColor whiteColor];
        self.zx_navLineView.hidden = YES;
    }
    
    
    
    
    
    
}










// MARK: - protocol: KLBaseViewControllerNavigationProtocol.

- (BOOL)ds_showCustomNavigationBar {
    return YES;
}

- (NSString *)ds_titleForNavigationBar {
    return @"";
}

- (UIColor *)ds_colorForNavigationBar {
    return [UIColor whiteColor];
}

@end
