//
//  MDYMyGuidanceDetailRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/10.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYMyGuidanceDetailRequest : MDYBaseRequest
CopyStringProperty guidance_id;
@end

@interface MDYMyGuidanceDetailModel : NSObject
CopyStringProperty guidance_id;
CopyStringProperty name;
CopyStringProperty phone;
CopyStringProperty region;
CopyStringProperty address;

CopyStringProperty txt;
CopyStringProperty car_time;
CopyStringProperty type_name;
CopyStringProperty state;
CopyStringProperty a_name;

CopyStringProperty a_img;
@end

NS_ASSUME_NONNULL_END
