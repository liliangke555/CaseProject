//
//  MDYGoodsDetailsController.h
//  MaDanYang
//
//  Created by kckj on 2021/6/22.
//

#import "CKBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYGoodsDetailsController : CKBaseViewController
@property (nonatomic, assign) NSInteger goodsType; // 0 == 普通。1 == 秒杀。2== 拼团
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *addonGroupId;
@property (nonatomic, copy) NSString *seckillId;
@end

NS_ASSUME_NONNULL_END
