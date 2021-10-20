//
//  UIButton+CKButton.h
//  CloudKind
//
//  Created by kckj on 2021/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (CKButton)
+ (instancetype) k_buttonWithTarget:(id)target action:(SEL)sel;
+ (instancetype)k_mainButtonWithTarget:(id)target action:(SEL)sel;
- (void)adjustButtonImageViewUPTitleDownWithSpace:(CGFloat)spacing;
+ (instancetype)k_redButtonWithTarget:(id)target action:(SEL)sel;
@end

NS_ASSUME_NONNULL_END
