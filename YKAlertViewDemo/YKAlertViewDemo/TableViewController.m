//
//  TableViewController.m
//  YKAlertViewDemo
//
//  Created by Kelly on 2021/4/25.
//

#import "TableViewController.h"
#import "SysAlertHeader.h"

@interface TableViewController ()

@property (nonatomic, strong) NSArray * dataArray;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = @[
        @[
            @"常规两个按钮alert",
            @"简易调试使用alert，单按钮，标题默认为“确定”",
            @"不定数量按钮alert",
            @"无按钮toast样式",
            @"单文字HUD",
            @"带indicatorView的HUD",
            @"带进度条的HUD，成功！",
            @"带进度条的HUD，失败！",
        ],
        @[
            @"UIAlertController-Alert",
            @"UIAlertController-ActionSheet",
            @"无按钮Alert-toast",
            @"无按钮ActionSheet-toast",
            @"输入框UIAlertController-Alert",
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
    }else{
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
        label.text = @"AlertController";
        label.font = [UIFont boldSystemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
    }else{
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
    }
    
}

@end
