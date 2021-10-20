//
//  MDYSendMeesageView.h
//  MaDanYang
//
//  Created by kckj on 2021/6/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDYSendMeesageView : UIView
@property (nonatomic, copy) void(^didSendAction)(NSString *string);
@property (nonatomic, copy) void(^shopAction)(void);
@end

NS_ASSUME_NONNULL_END
