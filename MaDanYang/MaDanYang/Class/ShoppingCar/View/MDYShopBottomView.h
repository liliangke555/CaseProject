//
//  MDYShopBottomView.h
//  MaDanYang
//
//  Created by kckj on 2021/6/4.
//

#import <UIKit/UIKit.h>
#import "MDYShoppingCarListRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYShopBottomView : UIView
@property (nonatomic, assign, getter=isSelectedAll) BOOL selectedAll;
@property (nonatomic, copy) void(^didSelectedAll)(BOOL isAll);
@property (nonatomic, copy) void(^toPayAction)(void);
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, assign) CGFloat allMoney;
@end

NS_ASSUME_NONNULL_END
