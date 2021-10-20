//
//  MDYSigninAlterView.m
//  MaDanYang
//
//  Created by kckj on 2021/6/10.
//

#import "MDYSigninAlterView.h"
typedef void(^DidSelectedBlock)(void);
@interface MDYSigninAlterView ()
@property (nonatomic, copy) DidSelectedBlock didSelected;
@end
@implementation MDYSigninAlterView

- (instancetype)initWithImage:(MMPopupSetImageViewHandler)imageHandler title:(NSString *)title detail:(NSString *)detail button:(NSString *)buttonString didSelected:(void(^)(void))didSelected
{
    self = [super init];
    if (self) {
        self.type = MMPopupTypeAlert;
        [MMPopupWindow sharedWindow].touchWildToHide = YES;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(299);
        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        if (didSelected) {
            self.didSelected = didSelected;
        }
        MASViewAttribute *lastAttribute = self.mas_top;
        if (imageHandler) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [self addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self).with.insets(UIEdgeInsetsZero);
            }];
            imageHandler(imageView);
            lastAttribute = imageView.mas_bottom;
        }
        if ( title.length > 0 )
        {
            UILabel *titleLabel = [UILabel new];
            [self addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).offset(38);
                make.centerX.equalTo(self.mas_centerX);
            }];
            titleLabel.textColor = K_TextMoneyColor;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = KMediumFont(24);
            titleLabel.numberOfLines = 0;
            titleLabel.text = title;

            lastAttribute = titleLabel.mas_bottom;
        }
        if ( detail.length > 0 )
        {
            UILabel *detailLabel = [UILabel new];
            [self addSubview:detailLabel];
            [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).offset(24);
//                make.centerX.equalTo(self.mas_centerX);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 60, 0, 60));
            }];
            detailLabel.textColor = K_TextBlackColor;;
            detailLabel.textAlignment = NSTextAlignmentCenter;
            detailLabel.font = KSystemFont(16);
            detailLabel.numberOfLines = 0;
            detailLabel.text = detail;
            
            lastAttribute = detailLabel.mas_bottom;
        }
        
        UIButton *button = [UIButton mm_buttonWithTarget:self action:@selector(backButtonAction:)];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).mas_offset(92);
            make.centerX.equalTo(self.mas_centerX);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(190);
        }];
        [button setTitle:buttonString forState:UIControlStateNormal];
        [button setTitleColor:K_WhiteColor forState:UIControlStateNormal];
        [button.titleLabel setFont:KMediumFont(16)];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(button.mas_bottom).mas_offset(12);
            
        }];
    }
    return self;
}
- (void)backButtonAction:(UIButton *)sender {
    if (self.didSelected) {
        self.didSelected();
    }
    [self hide];
}
@end
