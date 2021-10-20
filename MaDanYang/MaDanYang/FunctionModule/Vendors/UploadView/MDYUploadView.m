//
//  MDYUploadView.m
//  MaDanYang
//
//  Created by kckj on 2021/6/21.
//

#import "MDYUploadView.h"

@implementation MDYUploadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type = MMPopupTypeAlert;
//        [self mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(299);
//        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        MASViewAttribute *lastAttribute = self.mas_top;
        
        UIImageView *bgImageView = [[UIImageView alloc] init];
        [self addSubview:bgImageView];
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self).insets(UIEdgeInsetsZero);
        }];
        [bgImageView setImage:[[UIImage imageNamed:@"upload_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(181, 120, 119, 120) resizingMode:UIImageResizingModeStretch]];
        
        UILabel *titleLabel = [UILabel new];
        [bgImageView addSubview:titleLabel];
        bgImageView.userInteractionEnabled = YES;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).offset(181);
            make.centerX.equalTo(self.mas_centerX);
            make.width.mas_equalTo(180);
            make.bottom.equalTo(bgImageView.mas_bottom).mas_offset(-90);
        }];
        titleLabel.textColor = KHexColor(0x007AFFFF);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = KMediumFont(16);
        titleLabel.numberOfLines = 0;
        titleLabel.text = @"发现新版本";
        self.titleLabel = titleLabel;
        
        UIButton *uploadButton = [UIButton mm_buttonWithTarget:self action:@selector(uploadButtonAction:)];
        [bgImageView addSubview:uploadButton];
        [uploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(bgImageView.mas_bottom).mas_offset(-36);
            make.centerX.equalTo(self.mas_centerX);
            make.height.mas_equalTo(34);
            make.width.mas_equalTo(170);
        }];
        [uploadButton setTitle:@"立即更新" forState:UIControlStateNormal];
        [uploadButton setTitleColor:KHexColor(0xFFFFFFFF) forState:UIControlStateNormal];
        [uploadButton setBackgroundImage:[UIImage mm_imageWithColor:KHexColor(0x007AFFFF)] forState:UIControlStateNormal];
        [uploadButton.titleLabel setFont:KBoldFont(17)];
        [uploadButton.layer setCornerRadius:8];
        [uploadButton setClipsToBounds:YES];
        
        lastAttribute = bgImageView.mas_bottom;
    
        UIButton *button = [UIButton mm_buttonWithTarget:self action:@selector(backButtonAction:)];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).mas_offset(40);
            make.centerX.equalTo(self.mas_centerX);
            make.height.width.mas_equalTo(50);
        }];
        [button setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(button.mas_bottom).mas_offset(12);
            
        }];
    }
    return self;
}
- (void)uploadButtonAction:(UIButton *)sender {
    if (self.didToUpload) {
        self.didToUpload();
    }
    [self hide];
}
- (void)backButtonAction:(UIButton *)sender {
    [self hide];
}
@end
