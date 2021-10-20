//
//  MDYIntegralAllDetailRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/28.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYIntegralAllDetailRequest : MDYBaseRequest
AssignProperty NSInteger limit;
AssignProperty NSInteger page;
@end

@interface MDYIntegralAllDetailModel : NSObject
CopyStringProperty integral_txt;
CopyStringProperty integral_num;
@end
NS_ASSUME_NONNULL_END
