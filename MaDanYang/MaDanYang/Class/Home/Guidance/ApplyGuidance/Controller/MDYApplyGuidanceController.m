//
//  MDYApplyGuidanceController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/9.
//

#import "MDYApplyGuidanceController.h"
#import "MDYPulicDynamicController.h"
#import "ZJDatePickerView.h"
#import "MDYAddDuidanceRequest.h"
#import "MDYPutQuestionTypeReqeust.h"
#import "MDYGuidanceTypeRequest.h"
#import "MDYCancelGuidanceRequest.h"
#import "MDYGetGuidanceIntegralRequest.h"
@interface MDYApplyGuidanceController ()<UITextViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, assign, getter=isCanEdit) BOOL canEdit; // 可否编辑
@property (nonatomic, strong) UIButton *typeButton;
@property (nonatomic, strong) UIButton *integralTypeButton;
@property (nonatomic, strong) UIButton *timeButton;
@property (nonatomic, strong) UIButton *integralButton;
@property (nonatomic, strong) UILabel *integralLabel;

@property (nonatomic, strong) UITextField *nameText;
@property (nonatomic, strong) UITextField *phoneText;
@property (nonatomic, strong) UITextField *addtrssText;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, copy) NSString *timeString;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) NSArray *typeArray;
@property (nonatomic, assign) NSInteger selectedTypeIndex;

@property (nonatomic, strong) NSArray *guidanceTypeArray;
@property (nonatomic, assign) NSInteger guidanceTypeIndex;
@end

@implementation MDYApplyGuidanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.guidanceModel) {
        self.navigationItem.title = @"预约详情";
        self.canEdit = NO;
        if ([self.guidanceModel.state integerValue] == 0) {
            self.type = 1;
        } else if ([self.guidanceModel.state integerValue] == 1) {
            self.type = 2;
        } else if ([self.guidanceModel.state integerValue] == 9) {
            self.type = 3;
        } else {
            self.type = 4;
        }
    } else {
        self.navigationItem.title = @"申请指导";
        self.canEdit = YES;
    }
    [self createView];
    [self getIntegral];
}
#pragma mark - IBAction
/// 选择时间
/// @param sender button
- (void)timeButtonAction:(UIButton *)sender {
    if (!self.isCanEdit) {
        return;
    }
    [self showTimeSelector];
}
/// 类型选择
/// @param data data
- (void)typeButtonActionWithData:(NSArray *)data {
    if (!self.isCanEdit) {
        return;
    }
    CKWeakify(self);
    MDYPickerView *view = [[MDYPickerView alloc] initWithTitle:@"指导方向" data:data didSelected:^(NSInteger index,NSString * _Nonnull string) {
        weakSelf.guidanceTypeIndex = index;
        [weakSelf.typeButton setTitle:string forState:UIControlStateNormal];
    }];
    [view show];
}
/// 提交按钮
/// @param sender button
- (void)pushButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.type == 0) {
        [self uploadGuidance];
    }
    if (self.type == 1) {
        [self cancleGuidance];
    }
    if (self.type == 3) {
        MDYPulicDynamicController *vc = [[MDYPulicDynamicController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
///  显示时间选择
- (void)showTimeSelector {
    CKWeakify(self);
    [ZJDatePickerView zj_showDatePickerWithTitle:@"选择时间" dateType:ZJDatePickerModeYMDHM defaultSelValue:nil minDate:[NSDate date] maxDate:nil isAutoSelect:NO resultBlock:^(NSString *selectValue) {
        weakSelf.timeString = selectValue;
    } cancelBlock:^{
        
    }];
}
/// 显示积分类型
/// @param array 数据
- (void)showPickerViewWithType:(NSArray *)array {
    CKWeakify(self);
    MDYPickerView *view = [[MDYPickerView alloc] initWithTitle:@"积分类型" data:array didSelected:^(NSInteger index ,NSString * _Nonnull string) {
        weakSelf.selectedTypeIndex = index;
        [weakSelf.integralTypeButton setTitle:string forState:UIControlStateNormal];
    }];
    [view show];
}
#pragma mark - Networking
/// 提交
- (void)uploadGuidance {
    NSString *integralId = @"";
    if (self.selectedTypeIndex < self.typeArray.count) {
        MDYPutQuestionTypeModel *model = self.typeArray[self.selectedTypeIndex];
        integralId = model.integral_type_id;
    }
    NSString *guidanceId = @"";
    if (self.guidanceTypeIndex < self.guidanceTypeArray.count) {
        MDYGuidanceTypeModel *model = self.guidanceTypeArray[self.guidanceTypeIndex];
        guidanceId = model.guidance_type_id;
    }
    
    MDYAddDuidanceRequest *request = [MDYAddDuidanceRequest new];
    request.name = self.nameText.text;
    request.phone = self.phoneText.text;
    request.region = self.addtrssText.text;
    request.address = self.addtrssText.text;
    request.time = self.timeString;
    request.type_id = guidanceId;
    request.integral_type_id = integralId;
    request.txt = self.textView.text;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            [MBProgressHUD showSuccessfulWithMessage:@"提交成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
/// 获取积分类型
- (void)getQeustionTypeData {
    MDYPutQuestionTypeReqeust *request = [MDYPutQuestionTypeReqeust new];
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        weakSelf.typeArray = response.data;
        if (weakSelf.typeArray.count > 0) {
            NSMutableArray *array = [NSMutableArray array];
            for (MDYPutQuestionTypeModel *model in weakSelf.typeArray) {
                [array addObject:model.type_name];
            }
            [weakSelf showPickerViewWithType:array];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
/// 获取指导类型
- (void)getGuidanceType {
    MDYGuidanceTypeRequest *request = [MDYGuidanceTypeRequest new];
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        weakSelf.guidanceTypeArray = response.data;
        if (weakSelf.guidanceTypeArray.count > 0) {
            NSMutableArray *array = [NSMutableArray array];
            for (MDYGuidanceTypeModel *model in weakSelf.guidanceTypeArray) {
                [array addObject:model.guidance_name];
            }
            [weakSelf typeButtonActionWithData:array];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}

/// 取消指导
- (void)cancleGuidance {
    MDYCancelGuidanceRequest *request = [MDYCancelGuidanceRequest new];
    request.guidance_id = self.guidanceModel.guidance_id;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            [MBProgressHUD showSuccessfulWithMessage:@"成功取消"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
- (void)getIntegral {
    MDYGetGuidanceIntegralRequest *request = [MDYGetGuidanceIntegralRequest new];
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            MDYGetGuidanceIntegralModel *model = response.data;
            [weakSelf.integralButton setTitle:[NSString stringWithFormat:@"%@积分/次",model.integral_num] forState:UIControlStateNormal];
            [weakSelf.integralLabel setText:[NSString stringWithFormat:@"*每次申请将会%@积分",model.integral_num]];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - Setter
- (void)setTimeString:(NSString *)timeString {
    _timeString = timeString;
    if (timeString.length > 0) {
        [self.timeLabel setHidden:NO];
        [self.timeLabel setText:timeString];
        [self.timeButton setTitle:@"" forState:UIControlStateNormal];
    } else {
        [self.timeLabel setHidden:YES];
        [self.timeButton setTitle:@"请选择" forState:UIControlStateNormal];
    }
}
#pragma mark - SetUpUI
- (void)createView {
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, KBottomSafeHeight + 69 + 33, 0));
    }];
    [scrollView setContentSize:CGSizeMake(0, 1000)];
    
    UIView *contentView = [[UIImageView alloc] init];
    [scrollView addSubview:contentView];
    [contentView setFrame:CGRectMake(0, 0, CK_WIDTH, 1000)];
    contentView.userInteractionEnabled = YES;
    MASViewAttribute *lastAttribute = contentView.mas_top;
    NSArray *titles = @[@"填写申请人",@"联系电话",@"地址"];
    for (int i = 0 ; i < titles.count ; i++) {
        NSString *title = titles[i];
        UILabel *titleLabel = [[UILabel alloc] init];
        [contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).mas_offset(16);
            make.top.equalTo(lastAttribute).mas_offset(24);
        }];
        [titleLabel setText:title];
        [titleLabel setNumberOfLines:0];
        [titleLabel setFont:KSystemFont(16)];
        [titleLabel setTextColor:K_TextBlackColor];
        
        UITextField *textField = [[UITextField alloc] init];
        [contentView addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom);
            make.left.right.equalTo(contentView).insets(UIEdgeInsetsMake(0, 16, 0, 16));
            make.height.mas_equalTo(52);
        }];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入" attributes:
            @{NSForegroundColorAttributeName:K_TextLightGrayColor,
                            NSFontAttributeName:KSystemFont(14)
            }];
        textField.attributedPlaceholder = attrString;
        [textField setTextColor:K_TextBlackColor];
        textField.userInteractionEnabled = self.isCanEdit;
        if (i == 0) {
            self.nameText = textField;
            [textField setText:self.guidanceModel.name];
        } else if (i == 1) {
            self.phoneText = textField;
            [textField setText:self.guidanceModel.phone];
        } else {
            self.addtrssText = textField;
            [textField setText:[NSString stringWithFormat:@"%@%@",self.guidanceModel.region?:@"",self.guidanceModel.address?:@""]];
        }
        UIView *userLineView = [[UIView alloc] init];
        [contentView addSubview:userLineView];
        [userLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(textField).insets(UIEdgeInsetsZero);
            make.top.equalTo(textField.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        [userLineView setBackgroundColor:K_SeparatorColor];
        lastAttribute = userLineView.mas_bottom;
    }
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        [contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).mas_offset(16);
            make.top.equalTo(lastAttribute).mas_offset(24);
        }];
        [titleLabel setText:@"时间"];
        [titleLabel setNumberOfLines:0];
        [titleLabel setFont:KSystemFont(16)];
        [titleLabel setTextColor:K_TextBlackColor];
        
        UIButton *button = [UIButton k_buttonWithTarget:self action:@selector(timeButtonAction:)];
        [contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom);
            make.left.right.equalTo(contentView).insets(UIEdgeInsetsMake(0, 16, 0, 16));
            make.height.mas_equalTo(52);
        }];
        [button setTitle:@"请选择" forState:UIControlStateNormal];
        [button setTitleColor:K_TextLightGrayColor forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"right_more_icon"] forState:UIControlStateNormal];
//        [button setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [button.titleLabel setFont:KSystemFont(14)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -(CK_WIDTH-32) / 2.0f + button.imageView.bounds.size.width, 0, (CK_WIDTH-32) / 2.0f - button.imageView.bounds.size.width)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, (CK_WIDTH-32) / 2.0f + button.imageView.bounds.size.width, 0, -(CK_WIDTH-32) / 2.0f - button.imageView.bounds.size.width)];
        self.timeButton = button;
        
        UILabel *label = [[UILabel alloc] init];
        [contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(button.mas_left);
            make.centerY.equalTo(button.mas_centerY);
        }];
        [label setText:@""];
        [label setNumberOfLines:0];
        [label setFont:KSystemFont(16)];
        [label setTextColor:K_TextBlackColor];
        [label setHidden:YES];
        self.timeLabel = label;
        if (!self.isCanEdit) {
            self.timeString = self.guidanceModel.car_time;
        }
                            
        UIView *userLineView = [[UIView alloc] init];
        [contentView addSubview:userLineView];
        [userLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(button).insets(UIEdgeInsetsZero);
            make.top.equalTo(button.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        [userLineView setBackgroundColor:K_SeparatorColor];
        lastAttribute = userLineView.mas_bottom;
    }
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        [contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).mas_offset(16);
            make.top.equalTo(lastAttribute).mas_offset(24);
        }];
        [titleLabel setText:@"指导内容"];
        [titleLabel setNumberOfLines:0];
        [titleLabel setFont:KSystemFont(16)];
        [titleLabel setTextColor:K_TextBlackColor];
        
        UITextView *textView = [[UITextView alloc] init];
        [self.view addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).mas_offset(8);
            make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, 0, 16));
            make.height.mas_equalTo(145);
        }];
        [textView setTextColor:K_TextBlackColor];
        [textView setFont:KSystemFont(15)];
        textView.delegate = self;
        textView.userInteractionEnabled = self.isCanEdit;
        [textView setText:self.guidanceModel.txt];
        self.textView = textView;
        
        UILabel *textPlaceholder = [[UILabel alloc] init];
        [textView addSubview:textPlaceholder];
        [textPlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(textView.mas_top).mas_offset(8);
            make.left.equalTo(textView.mas_left).mas_offset(5);
        }];
        [textPlaceholder setText:@"请输入"];
        [textPlaceholder setTextColor:K_TextLightGrayColor];
        [textPlaceholder setFont:KSystemFont(14)];
        self.placeholderLabel = textPlaceholder;
        
        if (!self.isCanEdit) {
            textPlaceholder.hidden= YES;
            [textView setText:self.guidanceModel.txt];
        }
        
                            
        UIView *userLineView = [[UIView alloc] init];
        [contentView addSubview:userLineView];
        [userLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(textView).insets(UIEdgeInsetsZero);
            make.top.equalTo(textView.mas_bottom).mas_offset(16);
            make.height.mas_equalTo(1);
        }];
        [userLineView setBackgroundColor:K_SeparatorColor];
        lastAttribute = userLineView.mas_bottom;
    }
    {
        UIView *view = [[UIView alloc] init];
        [contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).mas_offset(24);
            make.left.right.equalTo(contentView).insets(UIEdgeInsetsMake(0, 16, 0, 16));
            make.height.mas_equalTo(54);
        }];
        [view setBackgroundColor:K_WhiteColor];
        [view.layer setCornerRadius:6];
        [view.layer setShadowColor:K_ShadowColor.CGColor];
        [view.layer setShadowRadius:10.0f];
        [view.layer setShadowOffset:CGSizeMake(0, 2)];
        [view.layer setShadowOpacity:1.0f];
        [view setClipsToBounds:YES];
        view.layer.masksToBounds = NO;
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getGuidanceType)]];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(view.mas_left).mas_offset(11);
        }];
        [titleLabel setText:@"指导方向"];
        [titleLabel setFont:KSystemFont(16)];
        [titleLabel setTextColor:K_TextBlackColor];
        
        UIButton *button = [UIButton k_buttonWithTarget:self action:@selector(getGuidanceType)];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.right.equalTo(view.mas_right).mas_offset(-11);
        }];
        [button setTitle:@"请选择指导方向  " forState:UIControlStateNormal];
        [button setTitleColor:K_TextBlackColor forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"right_more_icon"] forState:UIControlStateNormal];
        [button setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [button.titleLabel setFont:KSystemFont(16)];
        self.typeButton = button;
        if (!self.canEdit) {
            [button setTitle:self.guidanceModel.type_name forState:UIControlStateNormal];
        }
        lastAttribute = view.mas_bottom;
    }
    if (self.canEdit) {
        UIView *view = [[UIView alloc] init];
        [contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).mas_offset(24);
            make.left.right.equalTo(contentView).insets(UIEdgeInsetsMake(0, 16, 0, 16));
            make.height.mas_equalTo(54);
        }];
        [view setBackgroundColor:K_WhiteColor];
        [view.layer setCornerRadius:6];
        [view.layer setShadowColor:K_ShadowColor.CGColor];
        [view.layer setShadowRadius:10.0f];
        [view.layer setShadowOffset:CGSizeMake(0, 2)];
        [view.layer setShadowOpacity:1.0f];
        [view setClipsToBounds:YES];
        view.layer.masksToBounds = NO;
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getQeustionTypeData)]];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(view.mas_left).mas_offset(11);
        }];
        [titleLabel setText:@"支付积分类型"];
        [titleLabel setFont:KSystemFont(16)];
        [titleLabel setTextColor:K_TextBlackColor];
        
        UIButton *button = [UIButton k_buttonWithTarget:self action:@selector(getQeustionTypeData)];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.right.equalTo(view.mas_right).mas_offset(-11);
        }];
        [button setTitle:@"请选择积分类型  " forState:UIControlStateNormal];
        [button setTitleColor:K_TextBlackColor forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"right_more_icon"] forState:UIControlStateNormal];
        [button setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [button.titleLabel setFont:KSystemFont(16)];
        self.integralTypeButton = button;
        lastAttribute = view.mas_bottom;
    }
    {
        UIView *view = [[UIView alloc] init];
        [contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).mas_offset(24);
            make.left.right.equalTo(contentView).insets(UIEdgeInsetsMake(0, 16, 0, 16));
            make.height.mas_equalTo(54);
        }];
        [view setBackgroundColor:K_WhiteColor];
        [view.layer setCornerRadius:6];
        [view.layer setShadowColor:K_ShadowColor.CGColor];
        [view.layer setShadowRadius:10.0f];
        [view.layer setShadowOffset:CGSizeMake(0, 2)];
        [view.layer setShadowOpacity:1.0f];
        [view setClipsToBounds:YES];
        view.layer.masksToBounds = NO;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(view.mas_left).mas_offset(11);
        }];
        [titleLabel setText:@"支付积分"];
        [titleLabel setNumberOfLines:0];
        [titleLabel setFont:KSystemFont(16)];
        [titleLabel setTextColor:K_TextBlackColor];
        
        UIButton *button = [UIButton k_buttonWithTarget:self action:@selector(timeButtonAction:)];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.right.equalTo(view.mas_right).mas_offset(-11);
        }];
        [button setTitle:@"500积分/次" forState:UIControlStateNormal];
        [button setTitleColor:K_TextMoneyColor forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"right_more_icon"] forState:UIControlStateNormal];
//        [button setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [button.titleLabel setFont:KSystemFont(16)];
        button.enabled = NO;
        self.integralButton = button;
        lastAttribute = view.mas_bottom;
    }
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        [contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).mas_offset(16);
            make.top.equalTo(lastAttribute).mas_offset(24);
        }];
        [titleLabel setText:@"*提交后会审核申请，有老师与您致电沟通"];
        [titleLabel setFont:KSystemFont(12)];
        [titleLabel setTextColor:K_TextLightGrayColor];
    }
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        [self.view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(scrollView.mas_bottom);
        }];
        [titleLabel setText:@"*每次申请将会扣除XX积分"];
        
        [titleLabel setFont:KSystemFont(12)];
        [titleLabel setTextColor:K_TextMoneyColor];
        self.integralLabel = titleLabel;
        
        UIButton *button = [UIButton k_mainButtonWithTarget:self action:@selector(pushButtonAction:)];
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 16, KBottomSafeHeight + 10, 16));
            make.height.mas_equalTo(49);
        }];
        [button.layer setBorderWidth:1];
        if (self.type == 0) {
            [button.layer setBorderColor:K_MainColor.CGColor];
            [button setTitle:@"提交申请" forState:UIControlStateNormal];
        } else if (self.type == 1) {
            [button setBackgroundImage:[UIImage ck_imageWithColor:K_WhiteColor] forState:UIControlStateNormal];
            [button.layer setBorderColor:K_SeparatorColor.CGColor];
            [button setTitleColor:K_TextLightGrayColor forState:UIControlStateNormal];
            [button setTitle:@"取消审核" forState:UIControlStateNormal];
        } else if (self.type == 2) {
            [button setBackgroundImage:[UIImage ck_imageWithColor:K_SeparatorColor] forState:UIControlStateNormal];
            [button.layer setBorderColor:K_SeparatorColor.CGColor];
            [button setTitleColor:K_TextLightGrayColor forState:UIControlStateNormal];
            [button setTitle:@"等待老师上门" forState:UIControlStateNormal];
        } else if (self.type == 3) {
            [button.layer setBorderColor:K_MainColor.CGColor];
            [button setTitle:@"发晒单" forState:UIControlStateNormal];
        } else {
            [button setBackgroundImage:[UIImage ck_imageWithColor:K_WhiteColor] forState:UIControlStateNormal];
            [button.layer setBorderColor:K_SeparatorColor.CGColor];
            [button setTitleColor:K_TextLightGrayColor forState:UIControlStateNormal];
            [button setTitle:@"已取消" forState:UIControlStateNormal];
        }
    }
    
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSInteger existedLength = textView.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = text.length;
    NSInteger pointLength = existedLength - selectedLength + replaceLength;
    if (pointLength > 0) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
    return YES;
}
@end
