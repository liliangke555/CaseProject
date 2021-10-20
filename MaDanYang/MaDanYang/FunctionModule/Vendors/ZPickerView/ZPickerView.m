//
//  ZPickerView.m
//  ZhiBaiYi
//
//  Created by kckj on 2020/12/4.
//

#import "ZPickerView.h"

typedef void(^DidSelectedBlock)(NSString *);
@interface ZPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) DidSelectedBlock didSelected;
@property (nonatomic, copy) NSString *selectedString;
@end

@implementation ZPickerView

- (instancetype)initWithTitle:(NSString *)title data:(NSArray <NSString *>*)data didSelected:(void(^)(NSString *string))didSelected {
    self = [super init];
    if (self) {
        self.dataSource = data;
        self.selectedString = data[0];
        if (didSelected) {
            self.didSelected = didSelected;
        }
        [MMPopupWindow sharedWindow].touchWildToHide = YES;
        self.type = MMPopupTypeSheet;
//        self.backgroundColor = [UIColor whiteColor];
        [self.layer setCornerRadius:6];
        [self setClipsToBounds:YES];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self).insets(UIEdgeInsetsMake(0, 8, 0, 8));
        }];
        [view setBackgroundColor:[UIColor whiteColor]];
        [view.layer setCornerRadius:4];
        [view setClipsToBounds:YES];
        
        MASViewAttribute *lastAttribute = self.mas_top;
        if (title.length > 0) {
            
            UILabel *label = [[UILabel alloc] init];
            [view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(view).insets(UIEdgeInsetsMake(24, 16, 0, 16));
            }];
            [label setTextColor:MMHexColor(0x333333FF)];
            [label setFont:[UIFont systemFontOfSize:14]];
            [label setNumberOfLines:0];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setText:title];
            
            lastAttribute = label.mas_bottom;
        }
        UIPickerView *pickerView = [[UIPickerView alloc] init];
        [view addSubview:pickerView];
        [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute);
            make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 16, 0, 16));
            make.height.mas_equalTo(180);
        }];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        lastAttribute = pickerView.mas_bottom;
        
        [view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastAttribute);
        }];
        
        lastAttribute = view.mas_bottom;
        
        UIView *buttonView = [[UIView alloc] init];
        [self addSubview:buttonView];
        [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 8, 0, 8));
            make.top.equalTo(lastAttribute).mas_offset(16);
        }];
        
        UIButton *cancelButton = [UIButton mm_buttonWithTarget:self action:@selector(cancelButtonAction:)];
        [view addSubview:cancelButton];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_top).mas_offset(24);
            make.left.equalTo(view.mas_left).mas_offset(16);
        }];
        [cancelButton setClipsToBounds:YES];
        [cancelButton setBackgroundImage:[UIImage mm_imageWithColor:MMHexColor(0xFFFFFFFF)] forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[UIImage mm_imageWithColor:MMHexColor(0x999999FF)] forState:UIControlStateHighlighted];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [cancelButton setTitleColor:MMHexColor(0x999999FF) forState:UIControlStateNormal];
        [cancelButton setTitleColor:MMHexColor(0x666666FF) forState:UIControlStateHighlighted];
        
        UIButton *enterButton = [UIButton mm_buttonWithTarget:self action:@selector(enterButtonAction:)];
        [buttonView addSubview:enterButton];
        [enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(buttonView.mas_top);
            make.left.right.equalTo(buttonView).insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(46);
        }];
        [enterButton.layer setCornerRadius:4];
        [enterButton setClipsToBounds:YES];
        [enterButton setBackgroundImage:[UIImage mm_imageWithColor:MMHexColor(0xFFFFFFFF)] forState:UIControlStateNormal];
        [enterButton setBackgroundImage:[UIImage mm_imageWithColor:MMHexColor(0x999999FF)] forState:UIControlStateHighlighted];
        [enterButton setTitle:@"确认" forState:UIControlStateNormal];
        [enterButton.titleLabel setFont:KMediumFont(16)];
        [enterButton setTitleColor:K_MainColor forState:UIControlStateNormal];
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
        self.didSelected(self.selectedString);
    }
    [self hide];
}
- (void)cancelButtonAction:(UIButton *)sender {
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
}
@end
