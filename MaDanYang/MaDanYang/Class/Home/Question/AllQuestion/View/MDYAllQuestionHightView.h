//
//  MDYAllQuestionHightView.h
//  MaDanYang
//
//  Created by kckj on 2021/6/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDYAllQuestionHightView : UIView
@property (nonatomic, strong) UISwitch *selectedSwitch;
@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, assign) BOOL isHight;
@property (nonatomic, copy) void(^didSelectedSwitch)(UIButton *sender);
@end

NS_ASSUME_NONNULL_END
