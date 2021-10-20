//
//  MDYIntegralGoodsListRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/3.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYIntegralGoodsListRequest : MDYBaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
CopyStringProperty type_id;
@end

@interface MDYIntegralGoodsListModel : NSObject
CopyStringProperty goods_id;
CopyStringProperty goods_name;
CopyStringProperty integral;
CopyStringProperty goods_img;
CopyStringProperty goods_info;
@end

NS_ASSUME_NONNULL_END
