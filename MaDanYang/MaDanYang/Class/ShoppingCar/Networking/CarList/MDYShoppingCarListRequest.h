//
//  MDYShoppingCarListRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/19.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYShoppingCarListRequest : MDYBaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
@end

@interface MDYShoppingCarListModel : NSObject
CopyStringProperty goods_id;
CopyStringProperty goods_name;
CopyStringProperty num;
CopyStringProperty goods_car_id;
CopyStringProperty goods_img;
CopyStringProperty price;
//CopyStringProperty is_default;

CopyStringProperty is_default;
@end

NS_ASSUME_NONNULL_END
