//
//  MDYGuidanceTypeRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/6.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYGuidanceTypeRequest : MDYBaseRequest

@end

@interface MDYGuidanceTypeModel : NSObject
CopyStringProperty guidance_type_id;
CopyStringProperty guidance_name;
@end

NS_ASSUME_NONNULL_END
