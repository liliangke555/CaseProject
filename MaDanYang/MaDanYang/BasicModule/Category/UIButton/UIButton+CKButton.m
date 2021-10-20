//
//  UIButton+CKButton.m
//  CloudKind
//
//  Created by kckj on 2021/5/12.
//

#import "UIButton+CKButton.h"

@implementation UIButton (CKButton)
+ (instancetype) k_buttonWithTarget:(id)target action:(SEL)sel {
    id btn = [self buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [btn setExclusiveTouch:YES];
    return btn;
}

+ (instancetype)k_mainButtonWithTarget:(id)target action:(SEL)sel {
    UIButton * btn = [self buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [btn setExclusiveTouch:YES];
    UIImage *img = [UIImage ck_imageWithColor:K_MainColor];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage ck_imageWithColor:KHexColor(0x999999FF)] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage ck_imageWithColor:KHexColor(0x515151FF)] forState:UIControlStateDisabled];
    [btn setTitleColor:K_WhiteColor forState:UIControlStateNormal];
    [btn setTitleColor:K_WhiteColor forState:UIControlStateDisabled];
    [btn.titleLabel setFont:KMediumFont(16)];
    [btn.layer setCornerRadius:4];
    [btn setClipsToBounds:YES];
    return btn;
}

+ (instancetype)k_redButtonWithTarget:(id)target action:(SEL)sel {
    UIButton * btn = [self buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [btn setExclusiveTouch:YES];
    UIImage *img = [UIImage ck_imageWithColor:K_TextMoneyColor];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage ck_imageWithColor:KHexColor(0x999999FF)] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage ck_imageWithColor:KHexColor(0x515151FF)] forState:UIControlStateDisabled];
    [btn setTitleColor:K_WhiteColor forState:UIControlStateNormal];
    [btn setTitleColor:K_WhiteColor forState:UIControlStateDisabled];
    [btn.titleLabel setFont:KMediumFont(16)];
    [btn.layer setCornerRadius:4];
    [btn setClipsToBounds:YES];
    return btn;
}

- (void)adjustButtonImageViewUPTitleDownWithSpace:(CGFloat)spacing {
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.frame.size.width, -self.imageView.frame.size.height-spacing/2, 0);
    // button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.frame.size.height-offset/2, 0, 0, -button.titleLabel.frame.size.width);
    // 由于iOS8中titleLabel的size为0，用上面这样设置有问题，修改一下即可
    self.imageEdgeInsets = UIEdgeInsetsMake(-self.titleLabel.intrinsicContentSize.height-spacing/2, 0, 0, -self.titleLabel.intrinsicContentSize.width);
}
@end
