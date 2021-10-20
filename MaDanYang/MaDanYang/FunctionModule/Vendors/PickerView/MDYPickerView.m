//
//  MDYPickerView.m
//  MaDanYang
//
//  Created by kckj on 2021/6/25.
//

#import "MDYPickerView.h"
typedef void(^DidSelectedBlock)(NSInteger ,NSString *);
@interface MDYPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) DidSelectedBlock didSelected;
@property (nonatomic, copy) NSString *selectedString;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation MDYPickerView

- (instancetype)initWithTitle:(NSString *)title data:(NSArray <NSString *>*)data didSelected:(void(^)(NSInteger index,NSString *string))didSelected
{
    self = [super init];
    if (self) {
        self.backgroundColor = K_WhiteColor;
        self.dataSource = data;
        self.selectedString = data[0];
        if (didSelected) {
            self.didSelected = didSelected;
        }
        [MMPopupWindow sharedWindow].touchWildToHide = YES;
        self.type = MMPopupTypeSheet;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        UIView *topView = [[UIView alloc] init];
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).mas_offset(-6);
            make.left.right.equalTo(self).insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(12);
        }];
        [topView setBackgroundColor:K_WhiteColor];
        [topView.layer setCornerRadius:6];
        [topView setClipsToBounds:YES];
        
        MASViewAttribute *lastAttribute = self.mas_top;
        if (title.length > 0) {
            
            UILabel *label = [[UILabel alloc] init];
            [self addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self).insets(UIEdgeInsetsMake(16, 16, 0, 16));
            }];
            [label setTextColor:MMHexColor(0x333333FF)];
            [label setFont:KMediumFont(16)];
            [label setNumberOfLines:0];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setText:title];
            
            lastAttribute = label.mas_bottom;
        }
        UIPickerView *pickerView = [[UIPickerView alloc] init];
        [self addSubview:pickerView];
        [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute);
            make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 16, 0, 16));
            make.height.mas_equalTo(180);
        }];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        lastAttribute = pickerView.mas_bottom;
        
        UIButton *backButton = [UIButton mm_buttonWithTarget:self action:@selector(backAction:)];
        [self addSubview:backButton];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).mas_offset(16);
            make.left.equalTo(self.mas_left).mas_offset(16);
        }];
        [backButton setTitle:@"  返回" forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
        [backButton setTitleColor:K_TextBlackColor forState:UIControlStateNormal];
        [backButton.titleLabel setFont:KSystemFont(16)];
        
        UIView *buttonView = [[UIView alloc] init];
        [self addSubview:buttonView];
        [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 8, 0, 8));
            make.top.equalTo(lastAttribute).mas_offset(16);
        }];
        
        UIButton *enterButton = [UIButton mm_buttonWithTarget:self action:@selector(enterButtonAction:)];
        [buttonView addSubview:enterButton];
        [enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(buttonView.mas_top);
            make.left.right.equalTo(buttonView).insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(46);
        }];
        [enterButton.layer setCornerRadius:4];
        [enterButton setClipsToBounds:YES];
        [enterButton setBackgroundImage:[UIImage mm_imageWithColor:K_MainColor] forState:UIControlStateNormal];
        [enterButton setBackgroundImage:[UIImage mm_imageWithColor:MMHexColor(0x999999FF)] forState:UIControlStateHighlighted];
        [enterButton setTitle:@"确认" forState:UIControlStateNormal];
        [enterButton.titleLabel setFont:KMediumFont(16)];
        [enterButton setTitleColor:K_WhiteColor forState:UIControlStateNormal];
        [enterButton setTitleColor:MMHexColor(0x666666FF) forState:UIControlStateHighlighted];
        [enterButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(buttonView.mas_bottom);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(buttonView.mas_bottom).offset(KBottomSafeHeight);
        }];
        
    }
    return self;
}
#pragma mark - IBAction
- (void)enterButtonAction:(UIButton *)sender {
    if (self.didSelected) {
        self.didSelected(self.selectedIndex,self.selectedString);
    }
    [self hide];
}
- (void)backAction:(UIButton *)sender {
    [self hide];
}
#pragma mark - UIPickerViewDelegate & UIPickerViewDataSource
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.dataSource count];
}
//设置每个选项显示的内容
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
     UILabel *retval = (id)view;
     if (!retval) {
      retval= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
     }
    NSString *string = @"";
    string = [self.dataSource objectAtIndex:row];
     retval.text = string;
     retval.font = KSystemFont(15);
    [retval setTextAlignment:NSTextAlignmentCenter];
    [retval setTextColor:K_TextBlackColor];
     return retval;
}
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    NSLog(@"-------");
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedString = [self.dataSource objectAtIndex:row];
    self.selectedIndex = row;
}
@end
