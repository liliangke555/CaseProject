//
//  MDYGuidanceDetailRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/9.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYGuidanceDetailRequest : MDYBaseRequest
CopyStringProperty post_id;
@end

@interface MDYGuidanceDetailModel : NSObject
CopyStringProperty post_id;
CopyStringProperty usename;
CopyStringProperty img;
CopyStringProperty title;
CopyStringProperty cartime;

CopyStringProperty txt;
@end

NS_ASSUME_NONNULL_END
