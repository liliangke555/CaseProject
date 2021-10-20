//
//  MDYOrderSynquerysRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/23.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYOrderSynquerysRequest : MDYBaseRequest
CopyStringProperty order_num;
@end

@interface MDYOrderSynquerysRouteModel : NSObject
CopyStringProperty areaCode;
CopyStringProperty areaName;
CopyStringProperty context;
CopyStringProperty ftime;
CopyStringProperty status;

CopyStringProperty time;
@end

@interface MDYOrderSynquerysModel : NSObject
CopyStringProperty com;
CopyStringProperty condition;
StrongProperty NSArray <MDYOrderSynquerysRouteModel *>* data;
@end

NS_ASSUME_NONNULL_END
