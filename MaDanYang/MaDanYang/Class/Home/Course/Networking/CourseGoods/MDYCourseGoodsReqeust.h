//
//  MDYCourseGoodsReqeust.h
//  MaDanYang
//
//  Created by kckj on 2021/7/10.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYCourseGoodsReqeust : MDYBaseRequest
AssignProperty NSInteger c_id;
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
@end
@interface MDYCourseGoodsModel : NSObject
CopyStringProperty goods_id;
CopyStringProperty goods_name;
CopyStringProperty goods_img;
CopyStringProperty is_pay;
CopyStringProperty is_seckill;

CopyStringProperty is_group;
CopyStringProperty price;
CopyStringProperty seckill_price;
CopyStringProperty group_price;
@end
NS_ASSUME_NONNULL_END
