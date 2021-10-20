//
//  MDYDistributionInfoRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/10.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYDistributionInfoRequest : MDYBaseRequest

AssignProperty NSInteger page;
AssignProperty NSInteger limit;
CopyStringProperty u_id;
@end

@interface MDYDistributionInfoListModel : NSObject
CopyStringProperty integral_txt;
CopyStringProperty integral_num;
@end

@interface MDYDistributionInfoModel : NSObject
CopyStringProperty sum;
StrongProperty NSArray <MDYDistributionInfoListModel *>*list;
@end

NS_ASSUME_NONNULL_END
