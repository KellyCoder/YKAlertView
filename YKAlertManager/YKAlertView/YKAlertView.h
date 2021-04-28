//
//  YKAlertView.h
//  YKAlertViewDemo
//
//  Created by Kevin on 2021/4/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YKAlertView;

typedef NS_ENUM(NSInteger, YKAlertActionStyle) {
    YKAlertActionStyleDefault = 0,
    YKAlertActionStyleCancel,
    YKAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, YKAlertControllerStyle) {
    YKAlertControllerStyleActionSheet = 0,
    YKAlertControllerStyleAlert
};

/// 操作按钮执行回调
/// @param alertSelf 本类对象
/// @param title title
/// @param buttonIndex 按钮下标(根据添加顺讯)
typedef void(^YKAlertActionBlock)(YKAlertView *alertSelf,NSString *title,NSUInteger buttonIndex);

/// YKAlertAppearanceBlock构造block,设置外观等
/// @param maker 配置对象
typedef void(^YKAlertAppearanceBlock)(YKAlertView *maker);

/// actionTitle链式配置
typedef YKAlertView * _Nonnull(^YKActionTitleBlock)(NSString *title);
/// actionTitle链式配置,支持自定义title颜色
typedef YKAlertView * _Nonnull(^YKActionTitleColorBlock)(NSString *title,UIColor *color);

@interface YKAlertAction : NSObject 

+ (instancetype)actionWithTitle:(nullable NSString *)title
                          color:(UIColor *)color
                          style:(YKAlertActionStyle)style;

@property (nullable, nonatomic, copy) NSString *title;
@property (nonatomic) YKAlertActionStyle style;
@property (nonatomic,strong) UIColor *color;

@end

@interface YKAlertView : UIView

/// 弹出类型
@property (nonatomic) YKAlertControllerStyle alertStyle;

// 链式构造,添加alertAction按钮
- (YKActionTitleBlock)addActionTitle;
// 链式构造,添加alertAction按钮,并自定义title颜色
- (YKActionTitleColorBlock)addActionTitleColor;

/// 自定义Alert弹窗
/// @param title title
/// @param message message
/// @param alertControllerStyle YKAlertControllerStyle
/// @param appearanceBlock alert配置过程
/// @param actionBlock 按钮响应回调
+ (void)yk_showAlertWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
         alertControllerStyle:(YKAlertControllerStyle)alertControllerStyle
              appearanceBlock:(YKAlertAppearanceBlock)appearanceBlock
                  actionBlock:(nullable YKAlertActionBlock)actionBlock;

#pragma mark - Alert

/// 自定义弹窗AlertView
/// @param title title
/// @param message message
/// @param appearanceBlock alert配置过程
/// @param actionBlock 按钮响应回调
+ (void)yk_showAlertViewWithTitle:(nullable NSString *)title
                          message:(nullable NSString *)message
                  appearanceBlock:(YKAlertAppearanceBlock)appearanceBlock
                      actionBlock:(nullable YKAlertActionBlock)actionBlock;

#pragma mark - ActionSheet

/// 自定义AlertSheet弹窗
/// @param title title
/// @param message message
/// @param appearanceBlock alert配置过程
/// @param actionBlock 按钮响应回调
+ (void)yk_showAlertSheetWithTitle:(nullable NSString *)title
                           message:(nullable NSString *)message
                   appearanceBlock:(YKAlertAppearanceBlock)appearanceBlock
                       actionBlock:(nullable YKAlertActionBlock)actionBlock;


@end

NS_ASSUME_NONNULL_END
