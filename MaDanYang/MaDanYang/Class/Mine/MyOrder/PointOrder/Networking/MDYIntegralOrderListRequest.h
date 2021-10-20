//
//  MDYIntegralOrderListRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/4.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYIntegralOrderListRequest : MDYBaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
AssignProperty NSInteger order_state;
@end

@interface MDYIntegralOrderListModel : NSObject
CopyStringProperty order_id;
CopyStringProperty type;
CopyStringProperty order_num;
CopyStringProperty order_name;
CopyStringProperty pay_price;

CopyStringProperty num;
CopyStringProperty state;
CopyStringProperty order_img;
@end

NS_ASSUME_NONNULL_END
