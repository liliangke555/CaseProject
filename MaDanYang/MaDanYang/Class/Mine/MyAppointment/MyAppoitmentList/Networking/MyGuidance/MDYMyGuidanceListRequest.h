//
//  MDYMyGuidanceListRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/10.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYMyGuidanceListRequest : MDYBaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
AssignProperty NSInteger state;
@end

@interface MDYMyGuidanceListModel : NSObject
CopyStringProperty guidance_id;
CopyStringProperty car_time;
CopyStringProperty type_name;
CopyStringProperty state;
CopyStringProperty a_name;

CopyStringProperty a_img;
@end

NS_ASSUME_NONNULL_END
