//
//  SysAlertController.h
//  YKAlertViewDemo
//
//  Created by Kevin on 2021/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SysAlertController;

/// 操作按钮执行回调
/// @param alertSelf 本类对象
/// @param action UIAlertAction对象
/// @param buttonIndex 按钮下标(根据添加顺讯)
typedef void(^SysAlertActionBlock)(SysAlertController *alertSelf,UIAlertAction *action,NSUInteger buttonIndex);

/// actionTitle链式配置
typedef SysAlertController * _Nonnull(^SysActionTitleBlock)(NSString *title);

NS_CLASS_AVAILABLE_IOS(8_0) @interface SysAlertController : UIAlertController

// toast持续时间,默认1s,SysAlertDurationDefault=1s
@property (nonatomic) NSTimeInterval toastDuration;
// Alert弹出后回调
@property (nullable, nonatomic, copy) void (^alertDidShown)(void);
// Alert关闭后回调
@property (nullable, nonatomic, copy) void (^alertDidDismiss)(void);

// 链式构造,添加alertAction按钮
- (SysActionTitleBlock)addActionTitle;
// 链式构造,添加alertAction cancel按钮
- (SysActionTitleBlock)addActionCancelTitle;
// 链式构造,添加alertAction destructive按钮
- (SysActionTitleBlock)addActionDestructiveTitle;

@end

#pragma mark - UIViewController扩展SysAlertController

/// SysAlertController构造block,设置外观等
/// @param maker 配置对象
typedef void(^SysAlertAppearanceBlock)(SysAlertController *maker);

@interface UIViewController (SysAlertController)

/// 显示Alert提示弹窗
/// @param title title
/// @param message message
/// @param appearanceBlock alert配置过程
/// @param actionBlock alert点击回调
- (void)yk_showAlertWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
              appearanceBlock:(SysAlertAppearanceBlock)appearanceBlock
                  actionBlock:(nullable SysAlertActionBlock)actionBlock NS_AVAILABLE_IOS(8_0);

/// 显示actionSheet提示弹窗
/// @param title title
/// @param message message
/// @param appearanceBlock alert配置过程
/// @param actionBlock alert点击回调
- (void)yk_showActionSheetWithTitle:(nullable NSString *)title
                            message:(nullable NSString *)message
                    appearanceBlock:(SysAlertAppearanceBlock)appearanceBlock
                        actionBlock:(nullable SysAlertActionBlock)actionBlock NS_AVAILABLE_IOS(8_0);


@end


NS_ASSUME_NONNULL_END
