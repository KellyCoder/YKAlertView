//
//  SysAlertView.h
//  YKAlertViewDemo
//
//  Created by Kevin on 2021/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SysAlertType){
    SysAlertTypeNormal,
    SysAlertTypeToast,
    SysAlertTypeHUD
};

typedef NS_ENUM(NSUInteger, SysAlertHUDType){
    SysAlertHUDTypeText,
    SysAlertHUDTypeLoading,
    SysAlertHUDTypeProgress
};

/// 操作按钮执行回调
/// @param buttonIndex 按钮下标(根据添加顺讯)
typedef void(^SysAlertViewActionBlock)(NSUInteger buttonIndex);

@interface SysAlertView : UIAlertView

@property (nonatomic) SysAlertType alertType;
@property (nonatomic) SysAlertHUDType alertHUDType;
@property (nullable, nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nullable, nonatomic, strong) UIProgressView *progressView;
@property (nullable, nonatomic, copy) SysAlertViewActionBlock buttonClickBlock;


/// 两个按钮AlertView
/// @param title title
/// @param message message
/// @param cancelButtonTitle cancelButtonTitle
/// @param otherButtonTitle otherButtonTitle
/// @param cancelBlock 取消按钮回调
/// @param otherBlock 其他按钮回调
+ (void)yk_showAlertViewWithTitle:(nullable NSString *)title
                          message:(nullable NSString *)message
                cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                 otherButtonTitle:(nullable NSString *)otherButtonTitle
                cancelButtonBlock:(nullable SysAlertViewActionBlock)cancelBlock
                 otherButtonBlock:(nullable SysAlertViewActionBlock)otherBlock;

/// 自定义按钮数量AlertView
/// @param title title
/// @param message message
/// @param cancelButtonTitle cancelButtonTitle
/// @param buttonIndexBlock 按钮回调,通过按钮下标区分
/// @param otherButtonTitles 其他按钮标题,多参数
+ (void)yk_showAlertViewWithTitle:(nullable NSString *)title
                          message:(nullable NSString *)message
                cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                buttonIndexBlock:(nullable SysAlertViewActionBlock)buttonIndexBlock
                otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/// Toast提示
/// @param title title
/// @param message message
/// @param duration duration
/// @param completion 完成时的回调
+ (void)yk_showToastViewWithTitle:(nullable NSString *)title
                          message:(nullable NSString *)message
                         duration:(NSTimeInterval)duration
                       completion:(nullable SysAlertViewActionBlock)completion;

/// Loading HUD
/// @param title title
/// @param message message
+ (void)yk_showLoadingHUDWithTitle:(nullable NSString *)title
                           message:(nullable NSString *)message;

/// 关闭HUD
+ (void)yk_dismissHUD;

/// pregress HUD
/// @param title title
/// @param message message
+ (void)yk_showProgressHUDWithTitle:(nullable NSString *)title
                            message:(nullable NSString *)message;

/// 设置进度条进度值
/// @param progress 进度值
+ (void)yk_setHUDProgress:(float)progress;

/// 设置HUD状态
/// @param success 是否成功
/// @param title title
/// @param message message
+ (void)yk_setHUDWithIsSuccess:(BOOL)success
                         title:(NSString *)title
                       message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
