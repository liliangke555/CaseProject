//
//  MDYOrderGroupListRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/24.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYOrderGroupListRequest : MDYBaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
@end

NS_ASSUME_NONNULL_END
