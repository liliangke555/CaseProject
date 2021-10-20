//
//  MDYAddDuidanceRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/6.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYAddDuidanceRequest : MDYBaseRequest
CopyStringProperty name;
CopyStringProperty phone;
CopyStringProperty region;
CopyStringProperty address;
CopyStringProperty time;

CopyStringProperty type_id;
CopyStringProperty integral_type_id;
CopyStringProperty txt;
@end

@interface MDYAddDuidanceModel : NSObject
CopyStringProperty msg;
@end

NS_ASSUME_NONNULL_END
