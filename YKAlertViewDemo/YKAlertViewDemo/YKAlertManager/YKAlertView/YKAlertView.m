//
//  YKAlertView.m
//  YKAlertViewDemo
//
//  Created by Kevin on 2021/4/26.
//

#import "YKAlertView.h"
#import "YKActionSheetCell.h"

#define isIphoneX ({\
BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
if (!UIEdgeInsetsEqualToEdgeInsets([UIApplication sharedApplication].delegate.window.safeAreaInsets, UIEdgeInsetsZero)) {\
isPhoneX = YES;\
}\
}\
isPhoneX;\
})

#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//title距离屏幕左右间距和
#define kTitleSpacing 32
//标题与副标题之间的间距
#define kLabelSpacing 6
//alert默认宽度
#define kAlertViewWidth 280.f
//默认分割线颜色
#define kSeparatorColorDefault self.tableView.separatorColor.CGColor

static NSString *YKActionSheetCellKey = @"YKActionSheetCell";
static CGFloat const YKAlertCellDefaultHeight = 44.0f;
static NSTimeInterval const YKAnimationTimeIntervalDefault = 0.25;
static CGFloat const YKCornerDefault = 10.f;
//默认section高度
static CGFloat const YKsectionHeightDefault = 5.f;

#pragma mark - YKAlertAction

@implementation YKAlertAction

+ (instancetype)actionWithTitle:(nullable NSString *)title
                          color:(UIColor *)color
                          style:(YKAlertActionStyle)style{
    YKAlertAction *action = [YKAlertAction new];
    action.title = title;
    action.color = color;
    action.style = style;
    return action;
}

@end

#pragma mark - YKAlertView

@interface YKAlertView () <UITableViewDelegate,UITableViewDataSource>

typedef void(^YKAlertActionConfig)(YKAlertActionBlock actionBlock);


/** tableView */
@property (nonatomic,strong) UITableView *tableView;
/** 数据源 */
@property (nonatomic,strong) NSMutableArray *alertActionArray;
/** title */
@property (nonatomic,strong) NSString *title;
/** message */
@property (nonatomic,strong) NSString *message;
/** 操作按钮回调 */
@property (nonatomic,copy) YKAlertActionBlock alertActionBlock;

@end

@implementation YKAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message alertControllerStyle:(YKAlertControllerStyle)alertControllerStyle{
    self = [super init];
    if (!self) return nil;
    
    self.title = title;
    self.message = message;
    self.alertStyle = alertControllerStyle;
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    [self.tableView registerNib:[UINib nibWithNibName:YKActionSheetCellKey bundle:nil] forCellReuseIdentifier:YKActionSheetCellKey];
    
    return self;
}

#pragma mark - Public
- (YKActionTitleBlock)addActionTitle{
    return ^(NSString *title){
        YKAlertAction *actionModel = [YKAlertAction actionWithTitle:title color:UIColor.blackColor style:YKAlertActionStyleDefault];
        [self.alertActionArray addObject:actionModel];
        return self;
    };
}

- (YKActionTitleColorBlock)addActionTitleColor{
    return ^(NSString *title,UIColor *color){
        YKAlertAction *actionModel = [YKAlertAction actionWithTitle:title color:color style:YKAlertActionStyleDefault];
        [self.alertActionArray addObject:actionModel];
        return self;
    };
}

+ (void)yk_showAlertWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
         alertControllerStyle:(YKAlertControllerStyle)alertControllerStyle
              appearanceBlock:(YKAlertAppearanceBlock)appearanceBlock
                  actionBlock:(nullable YKAlertActionBlock)actionBlock{
    YKAlertView *alertView = [[YKAlertView alloc] initWithTitle:title message:message alertControllerStyle:alertControllerStyle];
    // 响应配置
    appearanceBlock(alertView);
    // 配置action
    alertView.alertActionConfig(actionBlock);
    
    alertView.alertActionBlock = actionBlock;
    
    [[alertView keyWindow] addSubview:alertView];
}

+ (void)yk_showAlertViewWithTitle:(nullable NSString *)title
                          message:(nullable NSString *)message
                  appearanceBlock:(YKAlertAppearanceBlock)appearanceBlock
                      actionBlock:(nullable YKAlertActionBlock)actionBlock{
    [self yk_showAlertWithTitle:title
                        message:message
           alertControllerStyle:YKAlertControllerStyleAlert
                appearanceBlock:appearanceBlock
                    actionBlock:actionBlock];
}


+ (void)yk_showAlertSheetWithTitle:(nullable NSString *)title
                           message:(nullable NSString *)message
                   appearanceBlock:(YKAlertAppearanceBlock)appearanceBlock
                       actionBlock:(nullable YKAlertActionBlock)actionBlock{
    [self yk_showAlertWithTitle:title
                        message:message
           alertControllerStyle:YKAlertControllerStyleActionSheet
                appearanceBlock:appearanceBlock
                    actionBlock:actionBlock];
}

#pragma mark - Private
- (YKAlertActionConfig)alertActionConfig{
    return  ^(YKAlertActionBlock actionBlock){
        
        switch (self.alertStyle) {
            case YKAlertControllerStyleActionSheet:{
                [self alertActionSheetHandle];
            }
                break;
            default:{
                [self alertViewHandle];
            }
                break;
        }
        
    };
}

// 处理alert页面
- (void)alertViewHandle{
    
    CGFloat titleHeight = [self getLabelHeightWithText:self.title width:kAlertViewWidth-kTitleSpacing font:14];
    CGFloat messageHeight = [self getLabelHeightWithText:self.message width:kAlertViewWidth-kTitleSpacing font:12];
    CGFloat headViewHeight = titleHeight + messageHeight + kTitleSpacing + ((self.title.length > 0 && self.message.length > 0) ? kLabelSpacing : 0);
    
    if (self.alertActionArray.count > 2) {
        //更新视图
        CGFloat height = self.alertActionArray.count*YKAlertCellDefaultHeight + headViewHeight;
        self.tableView.frame = CGRectMake(0, 0, kAlertViewWidth, height);
        [self.tableView reloadData];
        
    }else{
        self.tableView.frame = CGRectMake(0, 0, kAlertViewWidth, YKAlertCellDefaultHeight + headViewHeight);
        
        if (self.alertActionArray.count == 2) { //2个按钮的单独处理
            for (int i = 0; i < self.alertActionArray.count; i++) {
                YKAlertAction *actionModel = self.alertActionArray[i];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setTitleColor:actionModel.color forState:UIControlStateNormal];
                [btn setTitle:actionModel.title forState:UIControlStateNormal];
                btn.tag = i + 1000;
                [btn addTarget:self action:@selector(alertNormalClick:) forControlEvents:UIControlEventTouchUpInside];
                btn.backgroundColor = self.tableView.backgroundColor;
                btn.frame = CGRectMake((kAlertViewWidth/2)*i, headViewHeight, kAlertViewWidth/2, YKAlertCellDefaultHeight);
                [self.tableView addSubview:btn];
                
                if (i == 1) { //分割线
                    CALayer *layer = [[CALayer alloc] init];
                    layer.frame = CGRectMake(kAlertViewWidth/2, headViewHeight, 1, YKAlertCellDefaultHeight);
                    layer.backgroundColor = kSeparatorColorDefault;
                    [self.tableView.layer addSublayer:layer];
                }
            }
        }
    }
    self.tableView.center = [self keyWindow].center;
    self.tableView.tableHeaderView = [self createHeadViewWithTitleHeight:titleHeight messageHeight:messageHeight headViewHeight:headViewHeight];
    [self bezierPathWithCornerRadii:CGSizeMake(YKCornerDefault, YKCornerDefault) byRoundingCorners:UIRectCornerAllCorners targetView:self.tableView];
    self.tableView.transform = CGAffineTransformMakeScale(0.95, 0.95);
    [UIView animateWithDuration:YKAnimationTimeIntervalDefault animations:^{
        self.tableView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

// 处理actionSheet页面
- (void)alertActionSheetHandle{
    
    CGFloat titleHeight = [self getLabelHeightWithText:self.title width:kSCREEN_WIDTH-kTitleSpacing font:14];
    CGFloat messageHeight = [self getLabelHeightWithText:self.message width:kSCREEN_WIDTH-kTitleSpacing font:12];
    CGFloat headViewHeight = titleHeight + messageHeight + kTitleSpacing + ((self.title.length > 0 && self.message.length > 0) ? kLabelSpacing : 0);
    if (self.title.length == 0 && self.message.length == 0) headViewHeight = 0.f;
    
    //更新视图
    CGFloat height = (self.alertActionArray.count + 1)*YKAlertCellDefaultHeight + YKsectionHeightDefault*2 + headViewHeight + (isIphoneX ? 20 : 0);
    self.tableView.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, height);
    if (self.title.length > 0 || self.message.length > 0) self.tableView.tableHeaderView = [self createHeadViewWithTitleHeight:titleHeight messageHeight:messageHeight headViewHeight:headViewHeight];
    
    [self.tableView reloadData];
    
    [self bezierPathWithCornerRadii:CGSizeMake(YKCornerDefault, YKCornerDefault) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight targetView:self.tableView];
    [UIView animateWithDuration:YKAnimationTimeIntervalDefault animations:^{
        self.tableView.frame = CGRectMake(0, kSCREEN_HEIGHT - height, kSCREEN_WIDTH, height);
    }];
}
//圆角
- (void)bezierPathWithCornerRadii:(CGSize)cornerRadii byRoundingCorners:(UIRectCorner)corners targetView:(UIView *)targetView{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:targetView.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = targetView.bounds;
    maskLayer.path = maskPath.CGPath;
    targetView.layer.mask = maskLayer;
}

- (UIView *)createHeadViewWithTitleHeight:(CGFloat)titleHeight messageHeight:(CGFloat)messageHeight headViewHeight:(CGFloat)headViewHeight{
    
    CGFloat headViewWidth = CGRectGetWidth(self.tableView.frame);
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headViewWidth, headViewHeight)];
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(kTitleSpacing/2, kTitleSpacing/2, headViewWidth - kTitleSpacing, titleHeight)];
    titleLb.numberOfLines = 0;
    titleLb.font = [UIFont boldSystemFontOfSize:14];
    titleLb.text = self.title;
    titleLb.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:titleLb];
    
    UILabel *messageLb = [[UILabel alloc] initWithFrame:CGRectMake(kTitleSpacing/2, (self.title.length > 0 ? CGRectGetMaxY(titleLb.frame) : 0) + (self.title.length == 0 ? kTitleSpacing/2 : kLabelSpacing), headViewWidth - kTitleSpacing, messageHeight)];
    messageLb.font = [UIFont systemFontOfSize:12];
    messageLb.numberOfLines = 0;
    messageLb.textAlignment = NSTextAlignmentCenter;
    messageLb.text = self.message;
    [headView addSubview:messageLb];
    
    CGFloat offsetY = (self.alertStyle == YKAlertControllerStyleAlert ? 1 : YKsectionHeightDefault);
    
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, headViewHeight - offsetY, headViewWidth, offsetY);
    layer.backgroundColor = kSeparatorColorDefault;
    [headView.layer addSublayer:layer];
    
    return headView;
}

/// 获取窗口
- (UIWindow *)keyWindow{
    UIWindow *foundWindow = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in windows) {
        if (window.isKeyWindow) {
            foundWindow = window;
            break;
        }
    }
    return foundWindow;
}

- (void)closeAlertView{
    
    if (self.alertStyle == YKAlertControllerStyleAlert) {
        [self removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:YKAnimationTimeIntervalDefault animations:^{
        CGFloat height = CGRectGetHeight(self.tableView.frame);
        self.tableView.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, height);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//根据宽度求高度 content 计算的内容  width 计算的宽度 font字体大小
- (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font:(CGFloat)font{
    if (text.length == 0) return 0;
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return rect.size.height;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //Alert形式不用自带取消按钮
    if (self.alertStyle == YKAlertControllerStyleAlert) return 1;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.alertActionArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YKAlertCellDefaultHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YKActionSheetCell *actionsheetCell = [tableView dequeueReusableCellWithIdentifier:YKActionSheetCellKey];
    if (!actionsheetCell) {
        actionsheetCell = [[YKActionSheetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:YKActionSheetCellKey];
    }
    NSString *titleStr = @"取消";
    if (indexPath.section == 0) {
        YKAlertAction *action = self.alertActionArray[indexPath.row];
        titleStr = action.title;
        actionsheetCell.titleLb.textColor = action.color;
    }else{
        actionsheetCell.titleLb.textColor = [UIColor redColor];
    }
    actionsheetCell.titleLb.text = titleStr;
    return actionsheetCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        YKAlertAction *action = self.alertActionArray[indexPath.row];
        if (self.alertActionBlock) {
            self.alertActionBlock(self, action.title, indexPath.row);
        }
    }
    
    [self closeAlertView];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [UIView new];
    if (section == 0) footView.backgroundColor = self.tableView.separatorColor;
    
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.alertStyle == YKAlertControllerStyleAlert) return CGFLOAT_MIN;
    return YKsectionHeightDefault;
}

#pragma mark - Touch Event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.alertStyle == YKAlertControllerStyleAlert) return;
    [self closeAlertView];
}

- (void)alertNormalClick:(UIButton *)sender{
    YKAlertAction *action = self.alertActionArray[sender.tag - 1000];
    if (self.alertActionBlock) {
        self.alertActionBlock(self, action.title, sender.tag - 1000);
    }
    
    [self closeAlertView];
}

#pragma mark - Lazy Load
- (NSMutableArray <YKAlertAction *> *)alertActionArray{
    if (!_alertActionArray) {
        _alertActionArray = [NSMutableArray array];
    }
    return _alertActionArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [self addSubview:_tableView];
    }
    return _tableView;
}

@end
