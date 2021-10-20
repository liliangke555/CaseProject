//
//  MDYMyOrderListRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/29.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYMyOrderListRequest : MDYBaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
AssignProperty NSInteger order_state;
@end

@interface MDYMyOrderListModel : NSObject

CopyStringProperty order_id;
CopyStringProperty order_num;
CopyStringProperty order_name;
CopyStringProperty pay_price;
CopyStringProperty state;
CopyStringProperty num;
CopyStringProperty order_img;
CopyStringProperty type;
CopyStringProperty pay_type;
AssignProperty NSInteger order_type;
CopyStringProperty order_type_title;

@end

NS_ASSUME_NONNULL_END
