//
//  MDYCourseSelectView.m
//  MaDanYang
//
//  Created by kckj on 2021/6/23.
//

#import "MDYCourseSelectView.h"

@interface MDYCourseSelectView ()
@property (nonatomic, strong) NSArray *buttons;
@end

@implementation MDYCourseSelectView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIButton *leftButton = [UIButton k_buttonWithTarget:self action:@selector(buttonAction:)];
        [self addSubview:leftButton];
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).mas_offset(16);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(88);
            make.height.mas_equalTo(30);
        }];
        [leftButton setBackgroundImage:[UIImage ck_imageWithColor:K_WhiteColor] forState:UIControlStateNormal];
        [leftButton setBackgroundImage:[UIImage ck_imageWithColor:K_MainColor] forState:UIControlStateSelected];
        [leftButton setTitleColor:K_MainColor forState:UIControlStateNormal];
        [leftButton setTitleColor:K_WhiteColor forState:UIControlStateSelected];
        [leftButton.layer setCornerRadius:4];
        [leftButton setClipsToBounds:YES];
        [leftButton.layer setBorderWidth:1];
        [leftButton.titleLabel setFont:KSystemFont(16)];
        [leftButton.layer setBorderColor:K_MainColor.CGColor];
        [leftButton setTitle:@"介绍" forState:UIControlStateNormal];
        leftButton.selected = YES;
        leftButton.tag = 100;
        
        UIButton *midButton = [UIButton k_buttonWithTarget:self action:@selector(buttonAction:)];
        [self addSubview:midButton];
        [midButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(88);
            make.height.mas_equalTo(30);
        }];
        [midButton setBackgroundImage:[UIImage ck_imageWithColor:K_WhiteColor] forState:UIControlStateNormal];
        [midButton setBackgroundImage:[UIImage ck_imageWithColor:K_MainColor] forState:UIControlStateSelected];
        [midButton.layer setBorderWidth:1];
        [midButton setTitleColor:K_MainColor forState:UIControlStateNormal];
        [midButton setTitleColor:K_WhiteColor forState:UIControlStateSelected];
        [midButton.layer setCornerRadius:4];
        [midButton.titleLabel setFont:KSystemFont(16)];
        [midButton setClipsToBounds:YES];
        [midButton.layer setBorderColor:K_MainColor.CGColor];
        [midButton setTitle:@"目录" forState:UIControlStateNormal];
        midButton.tag = 101;
        
        UIButton *rightButton = [UIButton k_buttonWithTarget:self action:@selector(buttonAction:)];
        [self addSubview:rightButton];
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).mas_offset(-16);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(88);
            make.height.mas_equalTo(30);
        }];
        [rightButton setBackgroundImage:[UIImage ck_imageWithColor:K_WhiteColor] forState:UIControlStateNormal];
        [rightButton setBackgroundImage:[UIImage ck_imageWithColor:K_MainColor] forState:UIControlStateSelected];
        [rightButton setTitleColor:K_MainColor forState:UIControlStateNormal];
        [rightButton setTitleColor:K_WhiteColor forState:UIControlStateSelected];
        [rightButton.titleLabel setFont:KSystemFont(16)];
        [rightButton.layer setCornerRadius:4];
        [rightButton setClipsToBounds:YES];
        [rightButton.layer setBorderWidth:1];
        [rightButton.layer setBorderColor:K_MainColor.CGColor];
        [rightButton setTitle:@"关联商品" forState:UIControlStateNormal];
        rightButton.tag = 102;
        
        self.buttons = @[leftButton,midButton,rightButton];
    }
    return self;
}

- (void)buttonAction:(UIButton *)sender {
    if (sender.tag == 102) {
        if ([kUser.identity integerValue] == 0) {
            CKWeakify(self);
            MMPopupItemHandler block = ^(NSInteger index){
                if (weakSelf.didPushCertification) {
                    weakSelf.didPushCertification();
                }
            };
            NSArray *items = @[MMItemMake(@"确定", MMItemTypeHighlight, block)];
            MMAlertView *alterView = [[MMAlertView alloc] initWithTitle:@"温馨提示" image:nil detail:@"您还没有完成认证，请前去认证~" items:items];
            [alterView show];
            return;
        }
    }
    for (UIButton *button in self.buttons) {
        button.selected = NO;
    }
    sender.selected = YES;
    if (self.didSelected) {
        self.didSelected(sender.tag - 100);
    }
}
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    for (UIButton *button in self.buttons) {
        button.selected = NO;
    }
    UIButton *button = [self.buttons objectAtIndex:selectedIndex];
    button.selected = YES;
}
@end
