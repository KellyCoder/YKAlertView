//
//  SysAlertController.m
//  YKAlertViewDemo
//
//  Created by Kevin on 2021/4/25.
//

#import "SysAlertController.h"

// toast默认展示时间
static NSTimeInterval const SysAlertDurationDefault = 1.0f;

#pragma mark - AlertActionModel
@interface SysAlertActionModel : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic) UIAlertActionStyle style;

@end

@implementation SysAlertActionModel

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"";
        self.style = UIAlertActionStyleDefault;
    }
    return self;
}

@end

#pragma mark - SysAlertController

typedef void(^SysAlertActionConfig)(SysAlertActionBlock actionBlock);

@interface SysAlertController ()

@property (nonatomic, strong) NSMutableArray <SysAlertActionModel *> *alertActionArray;

@end

@implementation SysAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.alertDidDismiss) {
        self.alertDidDismiss();
    }
    
    if (self.showSaveSheetView) {
        [self.showSaveSheetView removeFromSuperview];
        self.showSaveSheetView = nil;
    }
}

#pragma mark -  public
- (instancetype)initAlertControllerWithTitle:(NSString *)title
                                     message:(NSString *)message
                              preferredStyle:(UIAlertControllerStyle)preferredStyle{
    
    if ((preferredStyle == UIAlertControllerStyleAlert) && !(title.length > 0) && (message.length > 0)) {
        title = @"";
    }
    
    self = [[self class] alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    
    if (!self) return nil;
    
    self.toastDuration = SysAlertDurationDefault;
    
    return self;
}

- (SysActionTitleBlock)addActionTitle{
    return ^(NSString *title){
        SysAlertActionModel *actionModel = [SysAlertActionModel new];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleDefault;
        [self.alertActionArray addObject:actionModel];
        return self;
    };
}

- (SysActionTitleBlock)addActionCancelTitle{
    return ^(NSString *title){
        SysAlertActionModel *actionModel = [SysAlertActionModel new];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleCancel;
        [self.alertActionArray addObject:actionModel];
        return self;
    };
}

- (SysActionTitleBlock)addActionDestructiveTitle{
    return ^(NSString *title){
        SysAlertActionModel *actionModel = [SysAlertActionModel new];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleDestructive;
        [self.alertActionArray addObject:actionModel];
        return self;
    };
}

#pragma mark - lazy load
- (NSMutableArray <SysAlertActionModel*> *)alertActionArray{
    if (!_alertActionArray) {
        _alertActionArray = [NSMutableArray array];
    }
    return _alertActionArray;
}

- (SysAlertActionConfig)alertActionConfig{
    return ^(SysAlertActionBlock actionBlock){
        if (self.alertActionArray.count > 0) {
            
            __weak typeof(self)weakSelf = self;
            [self.alertActionArray enumerateObjectsUsingBlock:^(SysAlertActionModel * _Nonnull actionModel, NSUInteger idx, BOOL * _Nonnull stop) {
                
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:actionModel.title style:actionModel.style handler:^(UIAlertAction * _Nonnull action) {
                    
                    __strong typeof(weakSelf)strongSelf = weakSelf;
                    if (actionBlock) {
                        actionBlock(strongSelf, action, idx);
                    }
                    
                }];
                
                [self addAction:alertAction];
            }];
            
        }else{
            NSTimeInterval duration = self.toastDuration > 0 ? self.toastDuration : SysAlertDurationDefault;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:NULL];
            });
        }
    };
}

@end

#pragma mark - UIViewController扩展SysAlertController

@implementation UIViewController (SysAlertController)

- (void)yk_showAlertWithPreferredStyle:(UIAlertControllerStyle)preferredStyle
                                 title:(nullable NSString *)title
                               message:(nullable NSString *)message
                       appearanceBlock:(SysAlertAppearanceBlock)appearanceBlock
                           actionBlock:(nullable SysAlertActionBlock)actionBlock{
    if (appearanceBlock) {
        SysAlertController *maker = [[SysAlertController alloc] initAlertControllerWithTitle:title message:message preferredStyle:preferredStyle];
        
        if (!maker) return;
        //链式添加action
        appearanceBlock(maker);
        //配置action
        maker.alertActionConfig(actionBlock);
        
        //适配ipad
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad && preferredStyle == UIAlertControllerStyleActionSheet) {
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            if (!maker.showSaveSheetView) {
                maker.showSaveSheetView = [[UIView alloc] init];
                [window addSubview:maker.showSaveSheetView];
            }
            maker.showSaveSheetView.center = window.center;
            maker.showSaveSheetView.backgroundColor = [UIColor redColor];
            
            maker.popoverPresentationController.sourceView = maker.showSaveSheetView;
            maker.popoverPresentationController.sourceRect = maker.showSaveSheetView.bounds;
            maker.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
        }
        
        if (maker.alertDidShown) {
            [self presentViewController:maker animated:YES completion:^{
                maker.alertDidShown();
            }];
        }else{
            [self presentViewController:maker animated:YES completion:nil];
        }
    }
}

- (void)yk_showAlertWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
              appearanceBlock:(SysAlertAppearanceBlock)appearanceBlock
                  actionBlock:(nullable SysAlertActionBlock)actionBlock NS_AVAILABLE_IOS(8_0){
    [self yk_showAlertWithPreferredStyle:UIAlertControllerStyleAlert title:title message:message appearanceBlock:appearanceBlock actionBlock:actionBlock];
}

- (void)yk_showActionSheetWithTitle:(nullable NSString *)title
                            message:(nullable NSString *)message
                    appearanceBlock:(SysAlertAppearanceBlock)appearanceBlock
                        actionBlock:(nullable SysAlertActionBlock)actionBlock NS_AVAILABLE_IOS(8_0){
    [self yk_showAlertWithPreferredStyle:UIAlertControllerStyleActionSheet title:title message:message appearanceBlock:appearanceBlock actionBlock:actionBlock];
}

@end
