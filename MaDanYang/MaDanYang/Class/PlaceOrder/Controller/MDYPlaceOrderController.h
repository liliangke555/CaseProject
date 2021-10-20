//
//  MDYPlaceOrderController.h
//  MaDanYang
//
//  Created by kckj on 2021/6/26.
//

#import "CKBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYPlaceOrderController : CKBaseViewController
@property (nonatomic, assign, getter=isCourse) BOOL course;
@property (nonatomic, copy) NSString *courseId;
@property (nonatomic, assign, getter=isShoppingCar) BOOL shoppingCar;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *addonGroupId;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *addonGrooupKaituanId;
@end

NS_ASSUME_NONNULL_END
