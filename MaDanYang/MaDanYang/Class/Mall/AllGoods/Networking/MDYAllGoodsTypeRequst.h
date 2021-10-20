//
//  MDYAllGoodsTypeRequst.h
//  MaDanYang
//
//  Created by kckj on 2021/7/12.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYAllGoodsTypeRequst : MDYBaseRequest

@end
@interface MDYAllGoodsTypeModel : NSObject
CopyStringProperty type_id;
CopyStringProperty type_name;
@end
NS_ASSUME_NONNULL_END
