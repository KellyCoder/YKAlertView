# YKAlertView 
 一、 仿微信底部弹窗,支持链式语法添加自定义按钮,可选添加标题与副标题,支持xib自定义视图, 可根据按钮index区分响应。
 
 二、 基于UIAlertView/UIAlertController封装，支持链式语法自定义按钮，可根据按钮index区分响应；
  
 详细用法参考[YKAlertView](https://github.com/KellyCoder/YKAlertView)
 ## SysAlertView ##
 ### 1.双按钮提示弹窗 ###
 ```
 [SysAlertView yk_showAlertViewWithTitle:@"两个按钮alert" message:@"按钮响应回调" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" cancelButtonBlock:^(NSUInteger buttonIndex) {
     NSLog(@"cancelButtonBlock 1");
 } otherButtonBlock:^(NSUInteger buttonIndex) {
     NSLog(@"otherButtonBlock 1");
 }];
 
```

### 2.自定义响应按钮数量 ###

```
[SysAlertView yk_showAlertViewWithTitle:@"自定义按钮数量" message:@"支持按钮响应回调,通过index区分" cancelButtonTitle:@"取消" buttonIndexBlock:^(NSUInteger buttonIndex) {
    NSLog(@"buttonIndex = %ld",buttonIndex);
} otherButtonTitles:@"确定",@"测试",@"自定义", nil];

```

### 3.Toast样式 ###

```
[SysAlertView yk_showToastViewWithTitle:@"Toast" message:@"简单的Toast样式" duration:1.0 completion:^(NSUInteger buttonIndex) {
    NSLog(@"Toast completion");
}];

```

### 4.Loading样式 ###

```
[SysAlertView yk_showLoadingHUDWithTitle:@"Loading" message:@"这是子标题"];
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [SysAlertView yk_dismissHUD];
});

```

### 5.进度条样式 ###

```
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

```
 
 ## SysAlertController ##
 ### 1.Alert提示弹窗,链式语法添加action ###
 
 ```
 [self yk_showAlertWithTitle:@"AlertController-Alert" message:@"基于UIAlertController封装,支持自定义添加Action和响应" appearanceBlock:^(SysAlertController * _Nonnull maker) {
     
     maker.addActionTitle(@"确定");
     maker.addActionCancelTitle(@"取消");
     
 } actionBlock:^(SysAlertController * _Nonnull alertSelf, UIAlertAction * _Nonnull action, NSUInteger buttonIndex) {
     NSLog(@"%@--%ld", action.title, buttonIndex);
 }];
 
 ```
 
 ### 2.ActionSheet样式,链式语法添加action ###
 
 ```
 [self yk_showActionSheetWithTitle:@"UIAlertController-ActionSheet" message:@"基于UIAlertController封装,支持自定义添加ActionSheet和响应" appearanceBlock:^(SysAlertController * _Nonnull maker) {
     
     maker.addActionTitle(@"确定");
     maker.addActionDestructiveTitle(@"destructive");
     maker.addActionCancelTitle(@"取消");
     
 } actionBlock:^(SysAlertController * _Nonnull alertSelf, UIAlertAction * _Nonnull action, NSUInteger buttonIndex) {
     NSLog(@"%@--%ld", action.title, buttonIndex);
 }];
 
 ```
 
 ### 3.Alert Toast样式,可自定义展示时间 ###
 
 ```
 
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
 
 ```
 
 
 ### 4.ActionSheet Toast样式,可自定义展示时间 ###
 
 ```
 
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
 
 ```
 
 ### 5.输入框样式 ###
 
 ```
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
 
 ```

## YKAlertSheet ##
### 1.带标题自定义AlertSheet提示弹窗,链式语法添加自定义action ###
 
```
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

```

### 2.无标题AlertSheet提示弹窗,链式语法添加action ###
```
[YKAlertView yk_showAlertSheetWithTitle:nil message:nil appearanceBlock:^(YKAlertView * _Nonnull maker) {
    maker.addActionTitle(@"标题1");
    maker.addActionTitle(@"标题2");
    maker.addActionTitle(@"标题3");
} actionBlock:^(YKAlertView * _Nonnull alertSelf, NSString * _Nonnull title, NSUInteger buttonIndex) {
    NSLog(@"自定义sheet %@--%ld", title, buttonIndex);
}];

```

## YKAlertView ##
### 1.常规Alert提示弹窗,两个操作按钮,按钮标题颜色支持自定义 ###
```
[YKAlertView yk_showAlertViewWithTitle:@"标题" message:@"副标题" appearanceBlock:^(YKAlertView * _Nonnull maker) {
    maker.addActionTitle(@"标题1");
    maker.addActionTitleColor(@"标题2",UIColor.cyanColor);
} actionBlock:^(YKAlertView * _Nonnull alertSelf, NSString * _Nonnull title, NSUInteger buttonIndex) {
    NSLog(@"自定义常规alert %@--%ld", title, buttonIndex);
}];

```

### 2.Alert提示弹窗,自定义操作按钮数量,按钮标题颜色支持自定义 ###
```
[YKAlertView yk_showAlertViewWithTitle:@"标题" message:@"副标题" appearanceBlock:^(YKAlertView * _Nonnull maker) {
    maker.addActionTitle(@"标题1");
    maker.addActionTitleColor(@"标题2",UIColor.redColor);
    maker.addActionTitle(@"标题3");
} actionBlock:^(YKAlertView * _Nonnull alertSelf, NSString * _Nonnull title, NSUInteger buttonIndex) {
    NSLog(@"自定义alert %@--%ld", title, buttonIndex);
}];

```


## YKAlertView自定义弹窗AlertSheet和AlertView都支持配置按钮标题颜色,参照如下方法设置 ##
```
// 链式构造,添加alertAction按钮,并自定义title颜色
- (YKActionTitleColorBlock)addActionTitleColor;
```

版本会持续更新,有问题请联系QQ:326054969,请添加备注,谢谢~
