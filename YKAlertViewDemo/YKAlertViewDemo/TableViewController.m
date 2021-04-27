//
//  TableViewController.m
//  YKAlertViewDemo
//
//  Created by Kelly on 2021/4/25.
//

#import "TableViewController.h"
#import "SysAlertHeader.h"

#import "YKAlertViewHeader.h"

@interface TableViewController ()

@property (nonatomic, strong) NSArray * dataArray;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = @[
        @[
            @"常规两个按钮alert",
            @"不定数量按钮alert",
            @"toast样式",
            @"Loading样式",
            @"progress样式",
        ],
        @[
            @"UIAlertController-Alert",
            @"UIAlertController-ActionSheet",
            @"无按钮Alert-toast",
            @"无按钮ActionSheet-toast",
            @"输入框UIAlertController-Alert",
        ],
        @[
            @"仿微信,自定义带标题AlertSheet",
            @"不带标题AlertSheet",
        ]
    ];
    
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArray = self.dataArray[section];
    return sectionArray.count;
}

#pragma mark - UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
        label.text = @"AlertView";
        label.font = [UIFont boldSystemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }else if (section == 1){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
        label.text = @"AlertController";
        label.font = [UIFont boldSystemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }else{
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
        label.text = @"YKAlertSheet";
        label.font = [UIFont boldSystemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0){
            
            [SysAlertView yk_showAlertViewWithTitle:@"两个按钮alert" message:@"按钮响应回调" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" cancelButtonBlock:^(NSUInteger buttonIndex) {
                NSLog(@"cancelButtonBlock 1");
            } otherButtonBlock:^(NSUInteger buttonIndex) {
                NSLog(@"otherButtonBlock 1");
            }];
            
        }else if (indexPath.row == 1){
            [SysAlertView yk_showAlertViewWithTitle:@"自定义按钮数量" message:@"支持按钮响应回调,通过index区分" cancelButtonTitle:@"取消" buttonIndexBlock:^(NSUInteger buttonIndex) {
                NSLog(@"buttonIndex = %ld",buttonIndex);
            } otherButtonTitles:@"确定",@"测试",@"自定义", nil];
        }else if (indexPath.row == 2){
            
            [SysAlertView yk_showToastViewWithTitle:@"Toast" message:@"简单的Toast样式" duration:1.0 completion:^(NSUInteger buttonIndex) {
                NSLog(@"Toast completion");
            }];
            
        }else if (indexPath.row == 3){
            
            [SysAlertView yk_showLoadingHUDWithTitle:@"Loading" message:@"这是子标题"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SysAlertView yk_dismissHUD];
            });
            
        }else if (indexPath.row == 4){
            
            [SysAlertView yk_showProgressHUDWithTitle:@"进度条" message:@"这是进度条的子标题"];
            __block float count = 0.;
            [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                count += 0.05;
                [SysAlertView yk_setHUDProgress:count];
                if (count > 1) {
                    [timer invalidate];
                    [SysAlertView yk_setHUDWithIsSuccess:YES title:@"成功了" message:@"成功子标题"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SysAlertView yk_dismissHUD];
                    });
                }
            }];
            
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0){
            [self yk_showAlertWithTitle:@"AlertController-Alert" message:@"基于UIAlertController封装,支持自定义添加Action和响应" appearanceBlock:^(SysAlertController * _Nonnull maker) {
                
                maker.addActionTitle(@"确定");
                maker.addActionCancelTitle(@"取消");
                
            } actionBlock:^(SysAlertController * _Nonnull alertSelf, UIAlertAction * _Nonnull action, NSUInteger buttonIndex) {
                NSLog(@"%@--%ld", action.title, buttonIndex);
            }];
        }else if (indexPath.row == 1){
            [self yk_showActionSheetWithTitle:@"UIAlertController-ActionSheet" message:@"基于UIAlertController封装,支持自定义添加ActionSheet和响应" appearanceBlock:^(SysAlertController * _Nonnull maker) {
                
                maker.addActionTitle(@"确定");
                maker.addActionDestructiveTitle(@"destructive");
                maker.addActionCancelTitle(@"取消");
                
            } actionBlock:^(SysAlertController * _Nonnull alertSelf, UIAlertAction * _Nonnull action, NSUInteger buttonIndex) {
                NSLog(@"%@--%ld", action.title, buttonIndex);
            }];
        }else if (indexPath.row == 2){
            [self yk_showAlertWithTitle:@"无按钮Alert-toast" message:@"支持自定义展示延时时间" appearanceBlock:^(SysAlertController * _Nonnull maker) {
                
                maker.toastDuration = 2.0;
                
                maker.alertDidShown = ^{
                    NSLog(@"alertDidShown");
                };
                
                maker.alertDidDismiss = ^{
                    NSLog(@"alertDidDismiss");
                };
                
            } actionBlock:^(SysAlertController * _Nonnull alertSelf, UIAlertAction * _Nonnull action, NSUInteger buttonIndex) {
                NSLog(@"%@--%ld", action.title, buttonIndex);
            }];
        }else if (indexPath.row == 3){
            
            [self yk_showActionSheetWithTitle:@"无按钮ActionSheet-toast" message:@"支持自定义展示延时时间" appearanceBlock:^(SysAlertController * _Nonnull maker) {
                
                maker.toastDuration = 2.0;
                
                maker.alertDidShown = ^{
                    NSLog(@"alertDidShown");
                };
                
                maker.alertDidDismiss = ^{
                    NSLog(@"alertDidDismiss");
                };
                
            } actionBlock:^(SysAlertController * _Nonnull alertSelf, UIAlertAction * _Nonnull action, NSUInteger buttonIndex) {
                NSLog(@"%@--%ld", action.title, buttonIndex);
            }];
            
        }else if (indexPath.row == 4){
            
            [self yk_showAlertWithTitle:@"输入框UIAlertController-Alert" message:@"添加输入框视图" appearanceBlock:^(SysAlertController * _Nonnull maker) {
                
                maker.addActionTitle(@"输入框视图1");
                maker.addActionTitle(@"输入框视图2");
                
                [maker addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"输入框1-请输入";
                }];
                [maker addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"输入框2-请输入";
                }];
                
            } actionBlock:^(SysAlertController * _Nonnull alertSelf, UIAlertAction * _Nonnull action, NSUInteger buttonIndex) {
                NSLog(@"%@--%ld", action.title, buttonIndex);
            }];
            
        }
    }else {
        
        if (indexPath.row == 0){
            [YKAlertView yk_showAlertSheetWithTitle:@"仿微信底部弹窗" message:@"支持链式语法添加自定义操作按钮,可选择添加标题和副标题" appearanceBlock:^(YKAlertView * _Nonnull maker) {
                maker.addActionTitle(@"标题1");
                maker.addActionTitle(@"标题2");
                maker.addActionTitle(@"标题3");
                maker.addActionTitle(@"标题4");
                maker.addActionTitle(@"标题5");
                maker.addActionTitle(@"标题6");
            } actionBlock:^(YKAlertView * _Nonnull alertSelf, NSString * _Nonnull title, NSUInteger buttonIndex) {
                NSLog(@"自定义sheet %@--%ld", title, buttonIndex);
            }];
        }else if (indexPath.row == 1){
            [YKAlertView yk_showAlertSheetWithTitle:nil message:nil appearanceBlock:^(YKAlertView * _Nonnull maker) {
                maker.addActionTitle(@"标题1");
                maker.addActionTitle(@"标题2");
                maker.addActionTitle(@"标题3");
            } actionBlock:^(YKAlertView * _Nonnull alertSelf, NSString * _Nonnull title, NSUInteger buttonIndex) {
                NSLog(@"自定义sheet %@--%ld", title, buttonIndex);
            }];
        }
        
    }
    
}

@end
