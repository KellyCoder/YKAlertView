//
//  SysAlertView.m
//  YKAlertViewDemo
//
//  Created by Kevin on 2021/4/25.
//

#import "SysAlertView.h"

//Toast默认显示时间
static NSTimeInterval const SysAlertToastShowDurationDefault = 1.0f;
//AlertView子视图key
static NSString *const SysAlertViewSubViewKey = @"accessoryView";


@interface SysAlertView () <UIAlertViewDelegate>

@end

@implementation SysAlertView

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitle:(NSString *)otherButtonTitle, ... NS_REQUIRES_NIL_TERMINATION{
    
    if (!(title.length > 0) && message.length > 0) title = @"";
    
    self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
    
    if (!self) return nil;
    
    return self;
}

+ (void)yk_showAlertViewWithTitle:(nullable NSString *)title
                          message:(nullable NSString *)message
                cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                 otherButtonTitle:(nullable NSString *)otherButtonTitle
                cancelButtonBlock:(nullable SysAlertViewActionBlock)cancelBlock
                 otherButtonBlock:(nullable SysAlertViewActionBlock)otherBlock{
 
    SysAlertView *alerView = [[SysAlertView alloc] initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitle, nil];
    alerView.alertType = SysAlertTypeNormal;
    alerView.buttonClickBlock = ^(NSUInteger buttonIndex) {
      
        if (buttonIndex == 0) {
            
            if (cancelBlock) {
                cancelBlock(buttonIndex);
            }
            
        }else{
            
            if (otherBlock) {
                otherBlock(buttonIndex);
            }
            
        }
        
    };
    
    [alerView show];
}

+ (void)yk_showAlertViewWithTitle:(nullable NSString *)title
                          message:(nullable NSString *)message
                cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                buttonIndexBlock:(nullable SysAlertViewActionBlock)buttonIndexBlock
                otherButtonTitles:(nullable NSString *)otherButtonTitles, ...{
    
    SysAlertView *alerView = [[SysAlertView alloc] initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitle:nil];
    alerView.alertType = SysAlertTypeNormal;
    alerView.buttonClickBlock = buttonIndexBlock;
    
    if (otherButtonTitles) {
        va_list args;   //指向个数可变的参数列表指针
        va_start(args, otherButtonTitles);  //获取第一个可变参数地址
        for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString *)) {
            [alerView addButtonWithTitle:arg];
        }
        va_end(args); //指针置空
    }
    
    [alerView show];
}

+ (void)yk_showToastViewWithTitle:(nullable NSString *)title
                          message:(nullable NSString *)message
                         duration:(NSTimeInterval)duration
                       completion:(nullable SysAlertViewActionBlock)completion{
    
    SysAlertView *alerView = [[SysAlertView alloc] initWithTitle:title message:message cancelButtonTitle:nil otherButtonTitle:nil];
    alerView.alertType = SysAlertTypeToast;
    
    alerView.buttonClickBlock = ^(NSUInteger buttonIndex) {
        if (buttonIndex == 0 && completion) {
            completion(buttonIndex);
        }
    };
    
    [alerView show];
    
    [alerView performSelector:@selector(dismissToastView:) withObject:alerView afterDelay:duration > 0 ? duration : SysAlertToastShowDurationDefault];
}

- (void)dismissToastView:(UIAlertView *)toast{
    [toast dismissWithClickedButtonIndex:0 animated:YES];
}

+ (void)yk_showLoadingHUDWithTitle:(nullable NSString *)title
                           message:(nullable NSString *)message{
    SysAlertView *alerView = [SysAlertView createCommonHUDWithHUDType:SysAlertHUDTypeLoading];
    alerView.title = title;
    alerView.message = message;
    [alerView show];
}

+ (void)yk_showProgressHUDWithTitle:(nullable NSString *)title
                            message:(nullable NSString *)message{
    SysAlertView *alerView = [SysAlertView createCommonHUDWithHUDType:SysAlertHUDTypeProgress];
    alerView.title = title;
    alerView.message = message;
    [alerView show];
}

+ (void)yk_setHUDProgress:(float)progress{
    SysAlertView *progressHUD = [SysAlertView getCommondHUD];
    progressHUD.progressView.progress = progress >= 1.0 ? 1.0 : progress;
}

#pragma mark - HUD Method
static SysAlertView *_commondHUD = nil;
+ (instancetype)createCommonHUDWithHUDType:(SysAlertHUDType)HUDType{
    if (!_commondHUD) {
        
        _commondHUD = [[SysAlertView alloc] initWithTitle:nil message:nil cancelButtonTitle:nil otherButtonTitle:nil, nil];
        _commondHUD.alertType = SysAlertTypeHUD;
        _commondHUD.alertHUDType = HUDType;
        
        switch (HUDType) {
            case SysAlertHUDTypeLoading:{
                UIActivityIndicatorViewStyle indicatorViewStyle = @available(iOS 13.0, *) ? UIActivityIndicatorViewStyleLarge : UIActivityIndicatorViewStyleWhiteLarge;
                UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:indicatorViewStyle];
                indicatorView.color = [UIColor redColor];
                [indicatorView startAnimating];
                _commondHUD.indicatorView = indicatorView;
                [_commondHUD setValue:indicatorView forKey:SysAlertViewSubViewKey];
            }
                break;
            case SysAlertHUDTypeProgress:{
                UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
                progressView.progressTintColor = [UIColor redColor];
                progressView.progress = 0.0;
                _commondHUD.progressView = progressView;
                [_commondHUD setValue:progressView forKey:SysAlertViewSubViewKey];
            }
                break;
            default:
                break;
        }
        
    }
    return _commondHUD;
}

+ (SysAlertView *)getCommondHUD{
    return _commondHUD;
}

+ (void)yk_setHUDWithIsSuccess:(BOOL)success
                         title:(NSString *)title
                       message:(NSString *)message{
    SysAlertView *hud = [SysAlertView getCommondHUD];
    hud.title = title;
    hud.message = message;
    switch (hud.alertHUDType) {
        case SysAlertHUDTypeLoading:{
            [hud.indicatorView stopAnimating];
            hud.indicatorView = nil;
        }
            break;
        case SysAlertHUDTypeProgress:{
            hud.progressView.progress = success ? 1.0 : 0;
        }
            break;
        default:
            break;
    }
}

+ (void)yk_dismissHUD{
    SysAlertView *hud = [SysAlertView getCommondHUD];
    switch (hud.alertHUDType) {
        case SysAlertHUDTypeLoading:{
            [hud.indicatorView stopAnimating];
            hud.indicatorView = nil;
        }
            break;
        case SysAlertHUDTypeProgress:{
        }
            break;
        default:
            break;
    }
    
    [hud dismissWithClickedButtonIndex:0 animated:YES];
}

+ (void)yk_clear{
    _commondHUD = nil;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.buttonClickBlock) {
        self.buttonClickBlock(buttonIndex);
    }
    self.buttonClickBlock = NULL;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (self.buttonClickBlock) {
        self.buttonClickBlock(buttonIndex);
    }
    self.buttonClickBlock = NULL;
    
    switch (self.alertType) {
        case SysAlertTypeToast:{
            [NSObject cancelPreviousPerformRequestsWithTarget:alertView selector:@selector(dismissToastView:) object:alertView];
        }
            break;
        case SysAlertTypeHUD:{
            [SysAlertView yk_clear];
        }
            break;
        default:
            break;
    }
}


@end
