//
//  MDYDistibutionListHeadView.h
//  MaDanYang
//
//  Created by kckj on 2021/6/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDYDistibutionListHeadView : UIView
@property (nonatomic, copy) NSString *buttonString;
@property (nonatomic, copy) void(^didToSearch)(NSString *string);
@property (nonatomic, copy) void(^didSelectedButton)(void);
@end

NS_ASSUME_NONNULL_END
